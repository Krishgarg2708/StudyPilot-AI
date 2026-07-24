<div align="center">

# 📚 StudyPilot AI

**Offline AI-Powered Study Buddy — no cloud API keys, ever.**

![Stack](https://img.shields.io/badge/FastAPI-009688?style=for-the-badge&logo=fastapi&logoColor=white)
![Stack](https://img.shields.io/badge/React-61DAFB?style=for-the-badge&logo=react&logoColor=black)
![Stack](https://img.shields.io/badge/Ollama-000000?style=for-the-badge)
![Stack](https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)
![Stack](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)

Everything runs on your own machine. Your data stays on your machine.

</div>

---

## ✨ Features

| Feature | What it does |
|---|---|
| **AI Chat** | Streaming chat with local Ollama (Gemma 3, Qwen, Phi, Mistral). Exam, Interview, Revision modes. |
| **PDF Chat (RAG)** | Upload PDF/DOCX/TXT/image → automatic OCR, chunking, FAISS embedding → ask questions grounded in your document. |
| **Smart Notes** | Generate structured study notes (summary, explanation, key concepts, examples, Mermaid mind map, interview questions) from any source. Export to PDF/DOCX/Markdown. |
| **Quiz Generator** | MCQ, True/False, Fill-in-blank, Short Answer, Coding questions at Easy/Medium/Hard difficulty. LLM-graded coding answers. |
| **Flashcards** | SM-2 spaced repetition with Easy/Hard marking and automatic scheduling. |
| **Study Planner** | Intelligent day-by-day plan from exam date + subjects. Weak subjects get 2× more sessions. Spaced revision reminders built in. |
| **Pomodoro Timer** | 25/5 or custom durations, circular progress ring, auto-advances phases, logs to analytics. |
| **Analytics** | Study streak, heatmap, weekly bar chart, weak/strong subjects by quiz accuracy. |
| **Voice Assistant** | Faster-Whisper STT + Piper TTS (offline). Read notes aloud. |
| **Search** | Keyword search across all content + semantic search (embedding similarity) across documents. |

---

## 🏗 Architecture

```
┌─────────────────────────────────────────────────────┐
│                   User's Browser                     │
│   React + TypeScript + Tailwind + shadcn/ui          │
│   Zustand state · React Router · Framer Motion       │
└───────────────────┬─────────────────────────────────┘
                    │ HTTP / SSE (nginx proxy)
┌───────────────────▼─────────────────────────────────┐
│              Nginx (port 3000)                       │
│  Serves static Vite build, proxies /api → backend   │
└───────────────────┬─────────────────────────────────┘
                    │
┌───────────────────▼─────────────────────────────────┐
│           FastAPI Backend (port 8000)                │
│  Auth (JWT+Refresh) · RAG Pipeline · AI Chat        │
│  Notes · Quiz · Flashcards · Planner · Analytics    │
│  Voice (Whisper STT + Piper TTS) · Search           │
└──────────┬──────────────────────┬───────────────────┘
           │                      │
┌──────────▼──────┐   ┌───────────▼──────────────────┐
│  PostgreSQL 16  │   │  File Storage (Docker volume) │
│  16 tables      │   │  /storage/uploads             │
│  JWT tokens     │   │  /storage/vector_store        │
│  All user data  │   │  /storage/exports             │
└─────────────────┘   └──────────────────────────────┘
           │
┌──────────▼──────────────────────────────────────────┐
│            Ollama (runs on host)                     │
│  gemma3 / qwen2.5 / phi4 / mistral                 │
│  all-MiniLM-L6-v2 embeddings (sentence-transformers)│
│  FAISS vector indexes (per-document)                │
└─────────────────────────────────────────────────────┘
```

---

## 📁 Project Structure

```
studypilot-ai/
├── docker-compose.yml
├── .env.example
│
├── backend/
│   ├── app/
│   │   ├── core/          # config, security (JWT/bcrypt), deps, rate limiter
│   │   ├── database/      # SQLAlchemy engine + session
│   │   ├── models/        # 16 SQLAlchemy ORM models
│   │   ├── schemas/       # Pydantic request/response schemas
│   │   ├── routes/        # FastAPI routers (1 per feature)
│   │   ├── services/      # Business logic layer
│   │   ├── rag/           # Extraction, chunking, FAISS vector store, retrieval
│   │   ├── embeddings/    # sentence-transformers wrapper
│   │   └── utils/         # JSON extraction, shared helpers
│   ├── alembic/           # Database migrations
│   ├── storage/           # uploads, vector_store, exports, voices
│   ├── requirements.txt
│   └── Dockerfile
│
├── frontend/
│   ├── src/
│   │   ├── components/
│   │   │   ├── ui/        # shadcn-style primitives (Button, Card, Dialog…)
│   │   │   ├── layout/    # AppLayout, Sidebar, Topbar
│   │   │   └── auth/      # ProtectedRoute
│   │   ├── pages/         # One page component per route
│   │   ├── store/         # Zustand: auth, UI, pomodoro
│   │   ├── lib/
│   │   │   ├── api-client.ts   # Axios + JWT refresh interceptor
│   │   │   └── api/            # Feature-specific API modules
│   │   ├── hooks/         # use-toast
│   │   └── types/         # TypeScript domain types
│   ├── nginx.conf
│   └── Dockerfile
```

---

## 🚀 Quick Start

### Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (or Docker + Docker Compose on Linux)
- [Ollama](https://ollama.ai/) installed and running

### 1. Install Ollama

```bash
# macOS / Linux
curl -fsSL https://ollama.ai/install.sh | sh

# Windows: download the installer from https://ollama.ai
```

> **Shortcut:** `./docker/ollama-setup.sh` automates steps 1 and 2 below (install,
> start the service, pull the default model) in one command — see
> [`docker/README.md`](docker/README.md).

### 2. Pull the AI models

```bash
# Default model (recommended — fast, capable)
ollama pull gemma3

# Optional alternatives
ollama pull qwen2.5
ollama pull phi4
ollama pull mistral

# Verify Ollama is running
ollama list
curl http://localhost:11434/api/tags
```

### 3. Clone & configure

```bash
git clone https://github.com/your-username/studypilot-ai.git
cd studypilot-ai

# Copy and edit the environment file
cp .env.example .env

# Generate real JWT secrets (run each command, paste output into .env)
python3 -c "import secrets; print(secrets.token_urlsafe(64))"
python3 -c "import secrets; print(secrets.token_urlsafe(64))"
```

### 4. Start the app

```bash
docker compose up --build
```

The first build takes 5–10 minutes (downloading Python/Node deps + sentence-transformers). Subsequent starts are fast.

- **Frontend:** http://localhost:3000
- **Backend API docs:** http://localhost:8000/docs

### 5. (Optional) Voice assistant setup

Voice requires two additional steps that can't be automated inside Docker:

**Speech-to-text** (Faster-Whisper) works automatically once the backend starts — the `base` Whisper model (~150MB) is downloaded on first use.

**Text-to-speech** (Piper):
```bash
# Download the Piper binary for your platform from:
# https://github.com/rhasspy/piper/releases
# Place it somewhere on your PATH, then download a voice model:

mkdir -p backend/storage/voices
wget https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/en/en_US/lessac/medium/en_US-lessac-medium.onnx \
     -O backend/storage/voices/en_US-lessac-medium.onnx
wget https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/en/en_US/lessac/medium/en_US-lessac-medium.onnx.json \
     -O backend/storage/voices/en_US-lessac-medium.onnx.json
```

---

## 🐧 Linux Note

On Linux, `host.docker.internal` doesn't resolve automatically. Either:

1. Add `extra_hosts: ["host.docker.internal:host-gateway"]` to the backend service (already in the compose file), **or**
2. Set `OLLAMA_BASE_URL=http://172.17.0.1:11434` in your `.env` (use `docker network inspect bridge` to confirm the gateway IP)

---

## 🔧 Running Locally (without Docker)

**Backend:**
```bash
cd backend
python -m venv venv && source venv/bin/activate
pip install -r requirements.txt

# Run Postgres locally or point DATABASE_URL at an existing instance
cp .env.example .env  # Edit to set DATABASE_URL

alembic upgrade head
uvicorn app.main:app --reload --port 8000
```

**Frontend:**
```bash
cd frontend
npm install
npm run dev  # starts at http://localhost:5173, proxies /api to :8000
```

---

## 🧪 Running Tests

```bash
cd backend
source venv/bin/activate
pytest tests/ -v
```

The test suite covers: JWT auth flow, RAG chunking (6 edge cases), FAISS vector store (7 cases), ingestion pipeline, JSON extraction (7 patterns), notes service (5 cases + repair logic), quiz grading (9 cases across all 5 question types), SM-2 spaced repetition algorithm (8 cases), study planner scheduling (8 cases), streak calculation (5 date-boundary cases), keyword/semantic search (5 cases).

---

## 🔒 Security

- Passwords hashed with bcrypt (passlib)
- JWT access tokens (30min) + rotating refresh tokens (7 days, stored server-side for revocation)
- Rate limiting on auth endpoints (10/min) and AI endpoints (20/min)
- All routes protected; cascade delete on account removal
- CORS configured to allow only the frontend origin

---

## 🗺 API Reference

Full interactive docs available at **http://localhost:8000/docs** when the backend is running.

Key endpoints:

| Method | Path | Description |
|---|---|---|
| POST | `/api/auth/signup` | Create account |
| POST | `/api/auth/login` | Login, get tokens |
| POST | `/api/auth/refresh` | Rotate refresh token |
| POST | `/api/documents/upload` | Upload PDF/DOCX/TXT/image |
| POST | `/api/documents/{id}/ask` | RAG question against a document |
| POST | `/api/chat/sessions/{id}/messages/stream` | SSE streaming chat |
| POST | `/api/notes/generate` | Generate structured notes |
| POST | `/api/quizzes/generate` | Generate quiz |
| POST | `/api/quizzes/{id}/submit` | Submit and grade |
| POST | `/api/flashcards/generate` | Generate flashcard deck |
| POST | `/api/flashcards/{id}/review` | Mark easy/hard (SM-2) |
| POST | `/api/study-plans` | Create study plan |
| GET  | `/api/analytics/summary` | Dashboard analytics |
| POST | `/api/voice/transcribe` | Speech to text |
| GET  | `/api/search/semantic` | Semantic search |

---

## 🛣 Future Improvements

- [ ] **Collaborative study rooms** — share decks and quizzes with other local users
- [ ] **Mobile app** — React Native wrapper around the same API
- [ ] **Mermaid mind map rendering** — render the generated `graph TD` diagrams inline using mermaid.js
- [ ] **OCR improvements** — GPU-accelerated Tesseract for faster scanned PDF processing
- [ ] **LLM fine-tuning integration** — PEFT/LoRA fine-tuning of local models on your own notes
- [ ] **Offline knowledge base** — crawl and index local websites/textbooks as documents
- [ ] **Browser extension** — clip web articles directly into PDF Chat
- [ ] **Exam Mode full-screen lock** — distraction-free exam simulation with timer
- [ ] **Import/Export Anki decks** — `.apkg` format compatibility for flashcards
- [ ] **Formula OCR** — detect and LaTeX-render math from scanned pages using pix2tex

---

## 🤝 Contributing

Pull requests welcome. Please run `tsc --noEmit` in frontend and `pytest tests/` in backend before submitting.

---

## 📄 License

MIT
