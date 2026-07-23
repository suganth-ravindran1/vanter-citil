from __future__ import annotations

from typing import Annotated, Literal

from fastapi import FastAPI, Header, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import StreamingResponse
from pydantic import BaseModel, Field

from .agents.graph import stream_chat_tokens
from .rag.retriever import CbtRetriever

app = FastAPI(
    title="FreeMind AI API",
    version="1.0.0",
    description="LangGraph + RAG backend for personalized multilingual wellness chat.",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

retriever = CbtRetriever()


class HistoryMessage(BaseModel):
    id: str | None = None
    role: Literal["user", "assistant", "system"] = "user"
    content: str
    createdAt: str | None = None


class ChatRequest(BaseModel):
    user_id: str
    message: str = Field(min_length=1)
    mode: Literal["generalSupport", "reframeThought", "situationSolver"] = "generalSupport"
    language: str = "English"
    use_personalization: bool = True
    history: list[HistoryMessage] = Field(default_factory=list)
    journal_snippets: list[str] = Field(default_factory=list)


class ChatResponse(BaseModel):
    reply: str
    sources: list[str] = Field(default_factory=list)
    mode: str
    language: str


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok", "service": "freemind-ai"}


@app.post("/api/v1/chat", response_model=ChatResponse)
def chat(payload: ChatRequest) -> ChatResponse:
    docs = retriever.retrieve(payload.message, k=3)
    reply_parts: list[str] = []
    for token in stream_chat_tokens(
        message=payload.message,
        mode=payload.mode,
        language=payload.language,
        use_personalization=payload.use_personalization,
        history=[h.model_dump() for h in payload.history],
        journal_snippets=payload.journal_snippets,
        retrieved_docs=docs,
    ):
        reply_parts.append(token)
    return ChatResponse(
        reply="".join(reply_parts).strip(),
        sources=[d["title"] for d in docs],
        mode=payload.mode,
        language=payload.language,
    )


@app.post("/api/v1/chat/stream")
def chat_stream(payload: ChatRequest) -> StreamingResponse:
    docs = retriever.retrieve(payload.message, k=3)

    def event_generator():
        import json

        for token in stream_chat_tokens(
            message=payload.message,
            mode=payload.mode,
            language=payload.language,
            use_personalization=payload.use_personalization,
            history=[h.model_dump() for h in payload.history],
            journal_snippets=payload.journal_snippets,
            retrieved_docs=docs,
        ):
            yield f"data: {json.dumps({'token': token})}\n\n"
        yield "data: [DONE]\n\n"

    return StreamingResponse(event_generator(), media_type="text/event-stream")


@app.get("/api/v1/resources/{category}")
def resources(category: str) -> dict:
    """Firebase/API-ready resource listing hook."""
    allowed = {"exercise", "meditation", "yoga", "book", "video", "cbt"}
    if category not in allowed:
        raise HTTPException(status_code=404, detail="Unknown category")
    return {"category": category, "items": [], "source": "api"}


@app.post("/api/v1/journal/reply")
def journal_reply(
    payload: dict,
    authorization: Annotated[str | None, Header()] = None,
) -> dict[str, str]:
    content = str(payload.get("content", ""))
    docs = retriever.retrieve(content, k=2)
    reply = (
        "Thank you for writing this down. "
        + (docs[0]["snippet"] if docs else "You showed up for yourself today — that matters.")
    )
    return {"reply": reply}


def create_app() -> FastAPI:
    return app
