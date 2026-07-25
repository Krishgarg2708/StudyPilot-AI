# `docker/`

The actual `Dockerfile`s for the frontend and backend live next to their respective
source (`frontend/Dockerfile`, `backend/Dockerfile`), and `docker-compose.yml` at the
project root wires everything together — that's the standard layout Docker Compose
expects for build contexts, so this folder isn't where those live.

This folder holds **host-side helper scripts** — things you run on your machine
*before* `docker compose up`, since Ollama itself runs on the host, not in a container.

- **`ollama-setup.sh`** — installs Ollama (if missing), starts the service, and pulls
  the default model (`gemma3`) plus any extra models you specify. Automates the
  "Install Ollama" and "Pull the AI models" steps from the main [README](../README.md).

  ```bash
  ./docker/ollama-setup.sh
  # or, to also grab alternate models:
  ./docker/ollama-setup.sh qwen2.5 phi4 mistral
  ```
