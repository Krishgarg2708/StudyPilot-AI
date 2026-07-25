<div align="center">

# 📚 StudyPilot AI

### Your entire study workflow — chat, notes, quizzes, flashcards, planning, voice — running 100% offline.

**No OpenAI key. No cloud bill. No data leaving your machine.**

<br/>

![FastAPI](https://img.shields.io/badge/FastAPI-009688?style=for-the-badge&logo=fastapi&logoColor=white)
![React](https://img.shields.io/badge/React_19-61DAFB?style=for-the-badge&logo=react&logoColor=black)
![TypeScript](https://img.shields.io/badge/TypeScript-3178C6?style=for-the-badge&logo=typescript&logoColor=white)
![Ollama](https://img.shields.io/badge/Ollama-000000?style=for-the-badge&logo=ollama&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL_16-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)

![FAISS](https://img.shields.io/badge/FAISS-Vector_Search-6E56CF?style=flat-square)
![Whisper](https://img.shields.io/badge/Faster--Whisper-STT-FF6F00?style=flat-square)
![Piper](https://img.shields.io/badge/Piper-TTS-00A67E?style=flat-square)
![Tailwind](https://img.shields.io/badge/TailwindCSS-38B2AC?style=flat-square&logo=tailwind-css&logoColor=white)
![Zustand](https://img.shields.io/badge/Zustand-State-764ABC?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)
![PRs](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)
![Made with](https://img.shields.io/badge/Made%20with-☕%20%2B%20%F0%9F%A7%A0-orange?style=flat-square)

<br/>

**[Quick Start](#-quick-start) · [Features](#-features) · [Architecture](#-architecture) · [API Docs](#-api-reference) · [Tests](#-running-tests) · [Roadmap](#-roadmap)**

</div>

---

## 💡 Why StudyPilot AI?

Every "AI study app" out there is a thin wrapper around an OpenAI API key — meaning your notes, PDFs, and exam questions get shipped to someone else's server, and your monthly bill scales with how hard you study.

**StudyPilot AI flips that.** The entire AI stack — LLM inference, embeddings, vector search, speech-to-text, and text-to-speech — runs locally via Ollama, sentence-transformers, and FAISS. Your documents never leave your machine. There's no API key to forget, no rate limit to hit, and no cost per token. Study as much as you want, for free, forever.

---

## ✨ Features

<table>
<tr>
<td width="50%" valign="top">

### 🧠 AI Chat
Streaming responses from local models (Gemma 3, Qwen 2.5, Phi-4, Mistral) with dedicated **Exam**, **Interview**, and **Revision** modes that change how the AI teaches.

### 📄 PDF Chat (RAG)
Drop in a PDF, DOCX, TXT, or scanned image. Auto-OCR + chunking + FAISS embedding turns it into a searchable knowledge base you can interrogate — answers are grounded in *your* document, not hallucinated.

### 📝 Smart Notes
One click turns any source into structured notes: summary, deep explanation, key concepts, worked examples, a Mermaid mind map, and likely interview questions. Export to PDF, DOCX, or Markdown.

### 🧩 Quiz Generator
MCQ, True/False, Fill-in-the-blank, Short Answer, and Coding questions across Easy/Medium/Hard. Coding answers are graded by the LLM, not string-matched.

</td>
<td width="50%" valign="top">

### 🎴 Flashcards
Full **SM-2 spaced repetition** — the same algorithm behind Anki. Mark Easy/Hard and the schedule adapts automatically.

### 🗓 Study Planner
Give it an exam date and your subjects; it builds a day-by-day plan, weighting weak subjects 2× more sessions, with spaced revision baked in.

### ⏱ Pomodoro Timer
25/5 or fully custom durations, animated circular progress, auto-advancing phases, and every session logged straight into your analytics.

### 📊 Analytics
Study streaks, activity heatmap, weekly effort chart, and weak/strong subject breakdown pulled from real quiz accuracy — not vibes.

### 🎙 Voice Assistant
Offline **Faster-Whisper** for speech-to-text and **Piper** for text-to-speech. Talk to your notes, or have them read back to you.

### 🔍 Search
Instant keyword search plus true **semantic search** (embedding similarity) across every document you've ever uploaded.

</td>
</tr>
</table>

---

## 🏗 Architecture

```
┌──────────────────────────────────────────────────────────┐
│                      User's Browser                        │
│   React 19 + TypeScript + Tailwind + shadcn/ui-style       │
│   Zustand state · React Router · Framer Motion             │
└────────────────────────┬────────────────────────────────┘
                          │ HTTP / SSE
┌────────────────────────▼────────────────────────────────┐
│                  Nginx (port 3000)                          │
│      Serves static Vite build, proxies /api → backend      │
└────────────────────────┬────────────────────────────────┘
                          │
┌────────────────────────▼────────────────────────────────┐
│               FastAPI Backend (port 8000)                   │
│  Auth (JWT + rotating refresh) · RAG Pipeline · AI Chat     │
│  Notes · Quiz · Flashcards · Planner · Analytics            │
│  Voice (Whisper STT + Piper TTS) · Search                  │
└─────────┬─────────────────────────────┬──────────────────┘
          │                             │
┌─────────▼─────────┐      ┌────────────▼────────────────┐
│  PostgreSQL 16     │      │  File Storage (Docker volume) │
│  16 relational      │      │  /storage/uploads              │
│  tables · JWT store │      │  /storage/vector_store         │
└────────────────────┘      │  /storage/exports              │
          │                  └────────────────────────────┘
┌─────────▼──────────────────────────────────────────────┐
│                Ollama (runs on host)                      │
│   gemma3 · qwen2.5 · phi4 · mistral                       │
│   all-MiniLM-L6-v2 embeddings (sentence-transformers)     │
│   FAISS vector indexes, one per document                  │
└────────────────────────────────────────────────────────┘
```

---

## 🧰 Tech Stack

| Layer | Technology |
|---|---|
| **Frontend** | React 19, TypeScript, Vite, Tailwind CSS, Radix UI primitives, Zustand, React Router 7, Framer Motion, Recharts, react-markdown + KaTeX + Mermaid |
| **Backend** | FastAPI, SQLAlchemy 2.0, Pydantic v2, Alembic migrations, slowapi rate limiting |
| **AI / RAG** | Ollama, sentence-transformers, FAISS, PyMuPDF, python-docx, pytesseract |
| **Voice** | Faster-Whisper (STT), Piper (TTS) |
| **Auth** | JWT access + rotating refresh tokens, bcrypt via passlib |
| **Database** | PostgreSQL 16 |
| **Infra** | Docker Compose, Nginx |

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
│   │   ├── routes/        # auth, chat, documents, notes, quiz,
│   │   │                  #   flashcards, study_plan, analytics,
│   │   │                  #   pomodoro_analytics, voice, search, settings
│   │   ├── services/      # business logic layer
│   │   ├── rag/           # extraction, chunking, FAISS vector store, retrieval
│   │   ├── embeddings/    # sentence-transformers wrapper
│   │   └── utils/         # JSON extraction, shared helpers
│   ├── alembic/           # database migrations
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
│   │   ├── pages/         # Dashboard, Chat, Documents, Notes, Quiz,
│   │   │                  #   Flashcards, Planner, Pomodoro, Analytics,
│   │   │                  #   Search, Settings, Auth
│   │   ├── store/         # Zustand: auth, UI, pomodoro
│   │   ├── lib/
│   │   │   ├── api-client.ts   # Axios + JWT refresh interceptor
│   │   │   └── api/            # feature-specific API modules
│   │   ├── hooks/         # use-toast
│   │   └── types/         # TypeScript domain types
│   ├── nginx.conf
│   └── Dockerfile
│
└── docker/                # setup scripts + docs
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

> **Shortcut:** `./docker/ollama-setup.sh` automates steps 1 & 2 (install, start
> the service, pull the default model) in one command — see [`docker/README.md`](docker/README.md).

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

# Generate real JWT secrets — run each, paste the output into .env
python3 -c "import secrets; print(secrets.token_urlsafe(64))"
python3 -c "import secrets; print(secrets.token_urlsafe(64))"
```

### 4. Start the app

```bash
docker compose up --build
```

First build takes 5–10 minutes (Python/Node deps + sentence-transformers download). Every start after that is fast.

| Service | URL |
|---|---|
| 🖥 Frontend | http://localhost:3000 |
| 📖 API Docs (Swagger) | http://localhost:8000/docs |

### 5. (Optional) Voice assistant setup

**Speech-to-text** works automatically — the Faster-Whisper `base` model (~150MB) downloads on first use.

**Text-to-speech (Piper):**
```bash
# Download the Piper binary for your platform from:
# https://github.com/rhasspy/piper/releases
# Place it on your PATH, then grab a voice model:

mkdir -p backend/storage/voices
wget https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/en/en_US/lessac/medium/en_US-lessac-medium.onnx \
     -O backend/storage/voices/en_US-lessac-medium.onnx
wget https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/en/en_US/lessac/medium/en_US-lessac-medium.onnx.json \
     -O backend/storage/voices/en_US-lessac-medium.onnx.json
```

---

## 🐧 Linux Note

`host.docker.internal` doesn't resolve automatically on Linux. Either:

1. Keep `extra_hosts: ["host.docker.internal:host-gateway"]` on the backend service (already in `docker-compose.yml`), **or**
2. Set `OLLAMA_BASE_URL=http://172.17.0.1:11434` in `.env` (confirm the gateway IP with `docker network inspect bridge`)

---

## 🔧 Running Locally (without Docker)

**Backend:**
```bash
cd backend
python -m venv venv && source venv/bin/activate
pip install -r requirements.txt

cp .env.example .env  # point DATABASE_URL at a local/remote Postgres instance

alembic upgrade head
uvicorn app.main:app --reload --port 8000
```

**Frontend:**
```bash
cd frontend
npm install
npm run dev  # http://localhost:5173, proxies /api to :8000
```

---

## 🧪 Running Tests

```bash
cd backend
source venv/bin/activate
pytest tests/ -v
```

Covers: JWT auth flow · RAG chunking (6 edge cases) · FAISS vector store (7 cases) · ingestion pipeline · JSON extraction (7 patterns) · notes service (5 cases + repair logic) · quiz grading (9 cases across all 5 question types) · SM-2 spaced repetition (8 cases) · study planner scheduling (8 cases) · streak calculation (5 date-boundary cases) · keyword/semantic search (5 cases).

---

## 🔒 Security

- Passwords hashed with **bcrypt** via `passlib`
- **JWT access tokens** (30 min) + **rotating refresh tokens** (7 days, server-side stored for revocation)
- Rate limiting on auth endpoints (10/min) and AI endpoints (20/min)
- Every route protected; cascade delete on account removal
- CORS locked down to the frontend origin only

---

## 🗺 API Reference

Full interactive docs live at **http://localhost:8000/docs** once the backend is running.

| Method | Path | Description |
|---|---|---|
| `POST` | `/api/auth/signup` | Create account |
| `POST` | `/api/auth/login` | Login, get tokens |
| `POST` | `/api/auth/refresh` | Rotate refresh token |
| `POST` | `/api/documents/upload` | Upload PDF/DOCX/TXT/image |
| `POST` | `/api/documents/{id}/ask` | RAG question against a document |
| `POST` | `/api/chat/sessions/{id}/messages/stream` | SSE streaming chat |
| `POST` | `/api/notes/generate` | Generate structured notes |
| `POST` | `/api/quizzes/generate` | Generate quiz |
| `POST` | `/api/quizzes/{id}/submit` | Submit and grade |
| `POST` | `/api/flashcards/generate` | Generate flashcard deck |
| `POST` | `/api/flashcards/{id}/review` | Mark easy/hard (SM-2) |
| `POST` | `/api/study-plans` | Create study plan |
| `GET`  | `/api/analytics/summary` | Dashboard analytics |
| `POST` | `/api/voice/transcribe` | Speech to text |
| `GET`  | `/api/search/semantic` | Semantic search |

---

## 🛣 Roadmap

- [ ] **Collaborative study rooms** — share decks and quizzes with other local users
- [ ] **Mobile app** — React Native wrapper around the same API
- [ ] **Inline Mermaid rendering** — render generated `graph TD` mind maps directly in the notes view
- [ ] **GPU-accelerated OCR** — faster scanned-PDF processing via Tesseract on GPU
- [ ] **LLM fine-tuning integration** — PEFT/LoRA fine-tuning of local models on your own notes
- [ ] **Offline knowledge base** — crawl and index local websites/textbooks as documents
- [ ] **Browser extension** — clip web articles directly into PDF Chat
- [ ] **Exam Mode full-screen lock** — distraction-free exam simulation with timer
- [ ] **Anki import/export** — `.apkg` format compatibility for flashcards
- [ ] **Formula OCR** — detect and LaTeX-render math from scanned pages via pix2tex

---

## 🤝 Contributing

Pull requests are welcome. Before submitting, please run:

```bash
cd frontend && tsc --noEmit
cd backend  && pytest tests/
```

---

## 📄 License

Released under the **MIT License**.

<div align="center">

Made for people who'd rather study than pay for tokens.

⭐ **Star this repo if StudyPilot AI helped you study smarter.**

<br/>

Made with ❤️ by **Krish**

</div>
