## NOTES

- `SKILL.md` provide a way to create a path for allowing the openclaw to execute some commands as you need, bypassing the plan of usage.
- OpenClaw uses a channel to execute commands in your computer.
- `SOUL.md` -> defines how the agent talks with you.
- `AGENTS.md` -> what it should do before each session and how to behave.
- `USER.md` -> defines facts about you.
- `IDENTITY.md` -> defined the facts about the agent.
- `MEMORY.md` -> long term memory.
- `memory/YYYY-MM-DD.md` -> short term memory.
- you can ask the agent to modify any of these files.
- `HEARTBEAT.md` -> defines periodic tasks that are checked after some time. If nothing needs attetion, it stays quiet. Do multiple tasks in a single session, sharing context/memory.
- cron jobs -> handle recurrent tasks. Run in different sessions.

---

### CLAUDE

- Hooks -> are commands that are run when claude executes an specific action.
- Cowork -> is like claude code, but it's meant for non coders.

---

### TINY CLAW

- TinyClaw is at some level lighter than openclaw, and runs multiple agents.
- In TinyClaw, you can have teams of agents.

--- 

### RAG

- Is the hability to retrieve relevant data, interpret and augment them, and generate something with that.
- retrieving models -> models that are designed to retrieve relevant data from a knowledge base.
- generative models -> generate data based on a context.
- RAG uses a combination of both models to levarege their capabilities.
- In general, RAG is a structure that has a part that retrieves data to feed the LLM with more context.
- Vector DB stores the embeddings of your documents.
- Embedding model queries the database when needed to get more context data.
- Helps reducing unreliable sources.
- Give the model access to fresh data.
- Data outside that used for training is called external data.
- Semantic search enhances RAG results. Good for large amounts of data.
- Is more efficient than retraining the model.
- Semantic search tries to understand more deeply the intent of the user.
- Semantic search uses NLP techniques, such as: Query analysis, Knowledge graph integration, content analysis, result return and retrieval.
- Semantic search is broader than vector search.
- Can also use graph DBs and Relational DBs for some cases.
- Graph DBs can improve the responses, since it has connections between knowledge. However, they require exact query matching.
- Using both DBs can leverage the best of these technologies.
- Chunks can be fixed sized or context aware.
- Reranking -> proccess the information and sort it by relevance.

#### Types of embedding

- sparse -> great for lexical matching. Keyword relevance.
- BERT -> semantic embedding. can capture nuances. Resource intensive.
- SentenceBERT -> semantic embedding. It's the balance between deep understanding and conscise.

#### Types of Retrieval

- Naive -> get the chunck that was stored and pass it to the synthesis.
- Sentence-window -> breaks the documents in smaller chunks, like sentences, and then for synteshis it returns to the context. Search for these smaller units.

#### Types or reranking

- lexical -> based on similarity.
- semantic -> based on the understanding and relavance for that context.
- learning to rank methods -> uses a model trained for ranking documents.
- Hybrid -> lexical+semantic using feedback or other signals.


#### General Steps

1. Get external data and use embedding models to transform that data into something that fits into a vector DB.
2. Query the database.
3. Augment the user input with the data retrieved from the database.
4. pass to the LLM
5. update the database once in a while to keep it up-to-date.

They can also have a step for chunking (spliting the data into smaller significant pieces). It would fit into the first step, right after getting the external data and right before embedding it.

#### NAIVE APPROACH

- The basic implmentation.
- Responses are given without feedback or optimization.
- Get the data and feed the LLM.
- It's simple.

1. Query the database.
2. Retrieve the top relevant documents.
3. Feed the LLM.

#### ADVANCED APPROACH

- Reranking, fine-tuning and feedback loops.
- More reliable, best performance and accuracy.
- More difficult.
- Production-grade applications.

1. Query the database.
2. Retrieve the documents.
3. Rank the documents based on the context.
4. Fuses the contexts to ensure coherence.
5. The generator used for the RAG generates a response.
6. Use some techniques to retrieve the feedback (such as clicks) to improve the generation and retrieving.

#### MODULAR APPROACH

- For different use cases.
- Components can be evaluated independently.

1. A query module recieves the input (prompt) and perform some transformations to enchance it for the next steps.
2. Uses Embedding-based similarity to retrieve documents from a vector database.
3. Theses documents are filtered and ranked.
4. An LLM generate a response trying to minimize hallucinations.
5. A post-processing module is employed to ensure accuracy, fact-checking, add citations, improves readability.
6. Generate the output for the user and uses the feedback loop to improve it overtime.

---

### FIRECRAWL MCP

- Used to scrape the web for data.


## REFERENCES

- [https://www.datacamp.com/tutorial/openclaw-ollama-tutorial](https://www.datacamp.com/tutorial/openclaw-ollama-tutorial)
- [https://www.datacamp.com/tutorial/moltbot-clawdbot-tutorial](https://www.datacamp.com/tutorial/moltbot-clawdbot-tutorial)
- [https://docs.ollama.com/integrations/openclaw](https://docs.ollama.com/integrations/openclaw)
- [https://github.com/TinyAGI/tinyclaw](https://github.com/TinyAGI/tinyclaw)
- [https://www.datacamp.com/tutorial/claude-cowork-tutorial](https://www.datacamp.com/tutorial/claude-cowork-tutorial)
- [https://www.datacamp.com/tutorial/claude-code-hooks](https://www.datacamp.com/tutorial/claude-code-hooks)
- [https://openclaw.ai/](https://openclaw.ai/)
- [https://docs.openclaw.ai/](https://docs.openclaw.ai/)
- [https://github.com/sipeed/picoclaw](https://github.com/sipeed/picoclaw)
- [https://github.com/HKUDS/nanobot](https://github.com/HKUDS/nanobot)
- [https://github.com/zeroclaw-labs/zeroclaw](https://github.com/zeroclaw-labs/zeroclaw)
- [https://dev.to/brooks_wilson_36fbefbbae4/zeroclaw-a-lightweight-secure-rust-agent-runtime-redefining-openclaw-infrastructure-2cl0](https://dev.to/brooks_wilson_36fbefbbae4/zeroclaw-a-lightweight-secure-rust-agent-runtime-redefining-openclaw-infrastructure-2cl0)
- [https://zeroclawlabs.ai/](https://zeroclawlabs.ai/)
- [https://www.datacamp.com/tutorial/moltbook-how-to-get-started](https://www.datacamp.com/tutorial/moltbook-how-to-get-started)
- [https://triggo.ai/blog/o-que-e-retrieval-augmented-generation/](https://triggo.ai/blog/o-que-e-retrieval-augmented-generation/)
- [https://www.salesforce.com/br/blog/what-is-retrieval-augmented-generation/](https://www.salesforce.com/br/blog/what-is-retrieval-augmented-generation/)
- [https://cloud.google.com/use-cases/retrieval-augmented-generation](https://cloud.google.com/use-cases/retrieval-augmented-generation)
- [https://aws.amazon.com/what-is/retrieval-augmented-generation/](https://aws.amazon.com/what-is/retrieval-augmented-generation/)
- [https://azure.microsoft.com/pt-br/resources/cloud-computing-dictionary/what-is-retrieval-augmented-generation-rag](https://azure.microsoft.com/pt-br/resources/cloud-computing-dictionary/what-is-retrieval-augmented-generation-rag)
- [https://www.ibm.com/think/topics/rag-techniques](https://www.ibm.com/think/topics/rag-techniques)
- [https://cloud.google.com/discover/what-is-semantic-search](https://cloud.google.com/discover/what-is-semantic-search)
- [https://www.datacamp.com/blog/what-is-retrieval-augmented-generation-rag](https://www.datacamp.com/blog/what-is-retrieval-augmented-generation-rag)
- [https://cloud.google.com/vertex-ai](https://cloud.google.com/vertex-ai)
- [https://docs.cloud.google.com/vertex-ai/generative-ai/docs/models/evaluation-overview](https://docs.cloud.google.com/vertex-ai/generative-ai/docs/models/evaluation-overview)
- [https://github.com/firecrawl/firecrawl-mcp-server](https://github.com/firecrawl/firecrawl-mcp-server)
- [https://www.datacamp.com/blog/what-is-retrieval-augmented-generation-rag](https://www.datacamp.com/blog/what-is-retrieval-augmented-generation-rag)
- [https://towardsdatascience.com/llm-rag-creating-an-ai-powered-file-reader-assistant/](https://towardsdatascience.com/llm-rag-creating-an-ai-powered-file-reader-assistant/)
- [https://medium.com/@tejpal.abhyuday/retrieval-augmented-generation-rag-from-basics-to-advanced-a2b068fd576c](https://medium.com/@tejpal.abhyuday/retrieval-augmented-generation-rag-from-basics-to-advanced-a2b068fd576c)
