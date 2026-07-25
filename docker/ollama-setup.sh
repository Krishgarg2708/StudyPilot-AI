#!/usr/bin/env bash
# StudyPilot AI — one-shot local Ollama setup.
#
# Automates README steps 1-2 ("Install Ollama" + "Pull the AI models"): installs
# Ollama if it's missing, starts the service, and pulls the default model (plus any
# extras you pass in). Safe to re-run — installation and model pulls are both no-ops
# if already done.
#
# Usage:
#   ./docker/ollama-setup.sh                      # installs Ollama + pulls gemma3
#   ./docker/ollama-setup.sh qwen2.5 phi4          # also pulls these extra models
set -euo pipefail

DEFAULT_MODEL="gemma3"
EXTRA_MODELS=("$@")

echo "== StudyPilot AI: Ollama setup =="

if ! command -v ollama >/dev/null 2>&1; then
  echo "-> Ollama not found. Installing..."
  case "$(uname -s)" in
    Linux|Darwin)
      curl -fsSL https://ollama.ai/install.sh | sh
      ;;
    *)
      echo "Automatic install isn't supported on this OS."
      echo "Please download Ollama manually from https://ollama.ai and re-run this script."
      exit 1
      ;;
  esac
else
  echo "-> Ollama already installed ($(ollama --version 2>/dev/null || echo 'version unknown'))."
fi

echo "-> Checking if the Ollama service is reachable on http://localhost:11434 ..."
if ! curl -fsS http://localhost:11434/api/tags >/dev/null 2>&1; then
  echo "-> Ollama service not responding — starting it in the background."
  (ollama serve >/tmp/ollama-serve.log 2>&1 &)
  # give it a moment to come up
  for _ in $(seq 1 10); do
    sleep 1
    if curl -fsS http://localhost:11434/api/tags >/dev/null 2>&1; then break; fi
  done
fi

echo "-> Pulling default model: $DEFAULT_MODEL"
ollama pull "$DEFAULT_MODEL"

for model in "${EXTRA_MODELS[@]}"; do
  echo "-> Pulling extra model: $model"
  ollama pull "$model"
done

echo ""
echo "== Done. Installed models: =="
ollama list

echo ""
echo "Ollama is ready at http://localhost:11434 — you can now run 'docker compose up --build'"
echo "from the project root (see the main README's Quick Start for the rest of the steps)."
