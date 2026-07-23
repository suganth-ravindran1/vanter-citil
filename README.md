# FreeMind AI

Calm AI mental wellness companion — Flutter Clean Architecture + Firebase-ready storage + FastAPI / LangGraph RAG backend.

## Stack

- **Flutter** — feature modules, Repository pattern, `get_it` DI, `flutter_bloc`, `go_router`
- **Design** — Apple-inspired white UI, soft lavender / blue / sage accents, animated logo + mountain silhouette
- **Auth** — email, Google/Apple stubs, profile setup (name, language, AI consent)
- **AI** — streaming chat via FastAPI SSE; offline CBT-style fallback in the app
- **Backend** — FastAPI + LangGraph agent + keyword RAG over CBT knowledge base

## Run the Flutter app

```bash
flutter pub get
flutter run
```

API base URL (default `http://127.0.0.1:8000`):

```bash
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:8000
```

## Run the AI backend

```bash
cd backend
py -m venv .venv
.\.venv\Scripts\activate
pip install -r requirements.txt
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

Health: `GET /health`  
Chat stream: `POST /api/v1/chat/stream`

## Navigation

| Surface | Destinations |
|--------|----------------|
| Bottom | Mind, Toolkit |
| Drawer | Journal, Sleep Recovery, Professional Support, Settings, Privacy, About |

## Architecture (`lib/`)

```
lib/
  core/           theme, DI, router, network, constants
  features/
    auth/         splash → login → profile setup
    mind/         AI chat, modes, voice, streaming, affirmations
    journal/      timeline + AI reply
    toolkit/      Mind & Body + Resources (strict category lists)
    sleep/        tracker + library
    professional_support/
    settings/
  shared/widgets/
```

## Firebase

Auth currently persists securely on-device (MVP). Wire Firebase with:

```bash
flutterfire configure
```

Then initialize in `main.dart` and swap `AuthRepositoryImpl` for a Firebase-backed repository.

## Disclaimer

FreeMind AI is a wellness companion, not a crisis service or substitute for professional care.
