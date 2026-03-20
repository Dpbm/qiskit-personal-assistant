# Qiskit Personal Assistant

This is my attempt to create a personal assistant using a `openclaw` like system.

My ideas was to have a docker setup with it and use a `Granite + Qiskit` based LLM to send me every day a new quantum algorithm on my discord server channel.

Even Though the project didn't work perfectly, it was a nice experiment.

## The Architecture

![arch](./assets/arch.png)

The architecture of this project uses 3 main components: `Zeroclaw`, `llama.cpp` and `librechat`.

The llama.cpp being the responsible to serve the model, librechat to be a nice webui to interact with it and Zeroclaw to manage the agents.

After some tests of models, I decided to only use the `granite` for chatting and switched to `nometron` provided by `openrouter` for the agent.

## How to Use?

run:

```bash
chmod +x setup-model.sh 
./setup-model.sh "<your bot key>" "<your discord user ID>" "<you discord channel ID>" "<your openrouter api key>"
make USERNAME=<userame> NAME=<name> EMAIL=<email> PASSWORD=<pass> MONGO_USER=<user> MONGO_PASSWORD=<pass> JWT_SECRET=<secret> JWT_REFRESH_SECRET=<secret>
```
```

After that, you can access these endpoints:

| endpoint | what |
|----------|------|
|localhost:42617|zeroclaw dashboard|
|localhost:5000|llama.cpp chat|
|localhost:3080|librechat|

you can also run:

```bash
make debug
```

to access the shell inside the container to check status and run commands.
```
```
```
