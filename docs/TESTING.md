# Testing Guide

StudyPilot AI's backend has a real automated test suite covering every route group:
auth, chat, smart notes, quizzes, flashcards, the study planner, pomodoro logging, and
analytics.

## Running the tests

```bash
cd backend
pip install -r requirements-dev.txt --break-system-packages   # or use a venv
PYTHONPATH=. pytest
```

You'll see output like:

```
tests/test_auth.py ..........
tests/test_chat.py .....
tests/test_flashcards.py ....
tests/test_health_and_settings.py ....
tests/test_notes.py ....
tests/test_pomodoro_and_analytics.py ....
tests/test_quiz.py ...
tests/test_study_plan.py .....

39 passed
```

## How the suite avoids needing a real Ollama / GPU setup

The whole point of StudyPilot AI is that it talks to a **local** Ollama instance and
local ML models (sentence-transformers, FAISS, faster-whisper). That's great for the
running app, but a CI box or your laptop shouldn't need a GPU and a pulled 4GB model
just to run unit tests.

`tests/conftest.py` handles this two ways:

1. **Heavy ML libraries** (`faiss`, `sentence-transformers`, `faster-whisper`) are
   replaced with lightweight in-memory fakes *before* `app` is imported. This means
   the RAG/embeddings/voice modules import successfully without pulling in PyTorch.
2. **The Ollama call itself** (`app.services.ollama_client.chat_completion`) is
   monkeypatched per-test wherever a route triggers an LLM call (chat messages, note
   generation, quiz generation, flashcard generation) so tests assert against a
   deterministic, known response instead of whatever a live local model happens to
   say.

Everything else — the FastAPI routing, Pydantic validation, JWT auth, SQLAlchemy
models, the SM-2 spaced-repetition scheduler, the study-plan generation algorithm, and
the rate limiter — runs for real, against a real (SQLite, in this test context)
database.

## What's covered

| Area | File |
|---|---|
| Signup / login / JWT / profile / password change / account deletion | `tests/test_auth.py` |
| Chat sessions and messages | `tests/test_chat.py` |
| Smart Notes generation, listing | `tests/test_notes.py` |
| Quiz generation and grading | `tests/test_quiz.py` |
| Flashcard generation and SM-2 review scheduling | `tests/test_flashcards.py` |
| Study Planner creation, listing, item completion | `tests/test_study_plan.py` |
| Pomodoro session logging and analytics summary | `tests/test_pomodoro_and_analytics.py` |
| Health check and settings | `tests/test_health_and_settings.py` |

Document upload/OCR/RAG-retrieval and the voice endpoints aren't covered by automated
tests yet, since they need real file I/O and audio fixtures — the fake FAISS/embedding
layer above is deliberately minimal (it doesn't actually store/retrieve vectors) so
those flows are best verified manually against a running Ollama + Docker Compose stack
per the main README.
