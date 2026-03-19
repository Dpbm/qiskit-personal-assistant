#!/usr/bin/env bash

set -eo pipefail

MODEL="granite-8b-qiskit.Q4_K_M.gguf"
MODEL_URL="https://huggingface.co/Qiskit/granite-8b-qiskit-GGUF/resolve/main/granite-8b-qiskit.Q4_K_M.gguf"
MODELS_PATH="./models"
LIBRECHAT_FILE="librechat.yml"
ZEROCLAW_FILE="zeroclaw.conf"
COMPOSE_FILE="compose.yml"
TEMPERATURE=0.4

DISCORD_TOKEN="$1"
DISCORD_USER="$2"
DISCORD_CHANNEL="$3"
OPENROUTER_API_KEY="$4"

if [ ! -n "$DISCORD_TOKEN" ] || [ ! -n "$DISCORD_USER" ] || [ ! -n "$DISCORD_CHANNEL" ] || [ ! -n "$OPENROUTER_API_KEY" ]; then
  echo "you must provide discord key, user ID, channel ID and Openrouter key!"
  exit 1
fi

if [ ! -d $MODELS_PATH ]; then
  echo "Creating path: $MODELS_PATH..."
  mkdir -p "$MODELS_PATH"
fi

if [ ! -f "${MODELS_PATH}/${MODEL}" ]; then
  echo "Downloading model..."
  curl -L --output-dir "$MODELS_PATH" -O "$MODEL_URL"
fi

echo "Generating config for librechat..."
cat <<EOF >"$LIBRECHAT_FILE"
version: 1.3.4
cache: true

interface: 
  customWelcome: 'Welcome to LibreChat! Enjoy your experience.'
  fileSearch: false
  privacyPolicy:
    externalUrl: 'https://librechat.ai/privacy-policy'
    openNewTab: true

  termsOfService:
    externalUrl: 'https://librechat.ai/tos'
    openNewTab: true
    modalAcceptance: true
    modalTitle: 'Terms of Service for LibreChat'
    modalContent: |
      # Terms and Conditions for LibreChat
  endpointsMenu: true
  modelSelect: true
  parameters: true
  sidePanel: true
  presets: true
  prompts:
    use: true
    create: true
    share: false
    public: false
  bookmarks: true
  multiConvo: true
  agents:
    use: true
    create: true
    share: false
    public: false
  peoplePicker:
    users: true
    groups: true
    roles: true
  marketplace:
    use: false
  fileCitations: true
  
registration:
  socialLogins: []

actions:
  allowedDomains: 
    - "qiskit-llm"

endpoints:
  custom:
    - name: "Qiskit"   
      apiKey: "1234"
      baseURL: "http://qiskit-llm:8080/v1"
      models:
          default: ["$MODEL"]
          fetch: true
      titleConvo: true
      titleModel: "Qiskit Model"
      summarize: false
      summaryModel: "Model to assist you during quantum programming"
      forcePrompt: false
      modelDisplayLabel: "Qiskit"
EOF

echo "Generating config for zeroclaw..."
cat <<EOF >"$ZEROCLAW_FILE"
default_provider = "openrouter"
default_model = "nvidia/nemotron-3-super-120b-a12b:free"
api_key = "$OPENROUTER_API_KEY"

[provider.llamacpp]
name = "llamacpp"
api_url = "http://qiskit-llm:8080/v1"
temperature = $TEMPERATURE
default_model = "$MODEL"

[security.audit]
enabled = false

[gateway]
host = "0.0.0.0"
port = 42617
allow_public_bind = true
require_pairing = false

[channels_config.discord]
bot_token = "$DISCORD_TOKEN"
allowed_users = ["$DISCORD_USER"]

[autonomy]
level = "supervised"
workspace_only = true
allowed_commands = [
    "git",
    "npm",
    "cargo",
    "ls",
    "cat",
    "grep",
    "find",
    "echo",
    "pwd",
    "wc",
    "head",
    "tail",
    "date",
    "zeroclaw"
]
auto_approve = ["send_discord", "shell"]

[agent]

[[agent.tool_filter_groups]]
mode = "dynamic"
tools = ["send_discord"]
keywords = ["send", "tell", "ask", "say"]

[cron]
enabled = true


EOF

echo "configuring compose file.."
cat <<EOF >"$COMPOSE_FILE"
services:
  qiskit-llm:
    container_name: qiskit-llm
    image: ghcr.io/ggml-org/llama.cpp:server-cuda
    ports:
      - '5000:8080'
    volumes:
      - './models:/models' 
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]       
    command: >
      -m /models/$MODEL
      --port 8080
      --host 0.0.0.0
      -n 1024
  
  webUI:
    container_name: librechat
    image: ghcr.io/danny-avila/librechat:v0.8.3-rc1
    restart: "always"
    ports:
      - '3080:3080'
    environment:
      - MONGO_URI=mongodb://\${MONGO_USER}:\${MONGO_PASSWORD}@mongo:27017/
      - JWT_SECRET=\${JWT_SECRET}
      - JWT_REFRESH_SECRET=\${JWT_REFRESH_SECRET}
      - ALLOW_REGISTRATION=false
      - ALLOW_SOCIAL_LOGIN=false
      - ALLOW_EMAIL_LOGIN=true
      - ALLOW_SOCIAL_REGISTRATION=false
    volumes:
      - './librechat.yml:/app/librechat.yaml'

  mongodb:
    container_name: mongo
    hostname: mongo
    image: mongo
    restart: always
    environment:
      MONGO_INITDB_ROOT_USERNAME: \${MONGO_USER}
      MONGO_INITDB_ROOT_PASSWORD: \${MONGO_PASSWORD}

  zeroclaw:
    container_name: zeroclaw
    hostname: zeroclaw
    build:
      context: .
      dockerfile: zeroclaw.Dockerfile
      args:
        RECIPIENT: $DISCORD_CHANNEL
    ports:
      - "42617:42617"
    volumes:
      - 'data:/.zeroclaw'
      - './zeroclaw.conf:/.zeroclaw/config.toml:ro'
      - './skills:/.zeroclaw/workspace/skills:ro'
      - './tools.md:/.zeroclaw/workspace/tools.md'

volumes:
  data:
    external: false
EOF
