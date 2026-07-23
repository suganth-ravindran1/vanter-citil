from __future__ import annotations

import re
from pathlib import Path


class CbtRetriever:
    """Lightweight keyword RAG over a local CBT knowledge base.

    Swap embedding store (Chroma / FAISS / Pinecone) without changing API shape.
    """

    def __init__(self, knowledge_dir: Path | None = None) -> None:
        root = Path(__file__).resolve().parents[2]
        self.knowledge_dir = knowledge_dir or (root / "knowledge")
        self._docs = self._load()

    def _load(self) -> list[dict[str, str]]:
        docs: list[dict[str, str]] = []
        if not self.knowledge_dir.exists():
            return self._fallback()
        for path in sorted(self.knowledge_dir.glob("*.md")):
            text = path.read_text(encoding="utf-8")
            docs.append(
                {
                    "id": path.stem,
                    "title": path.stem.replace("_", " ").title(),
                    "snippet": text.strip()[:400],
                    "body": text,
                }
            )
        return docs or self._fallback()

    def _fallback(self) -> list[dict[str, str]]:
        return [
            {
                "id": "thought_record",
                "title": "Thought Record",
                "snippet": "Catch automatic thoughts, examine evidence for/against, and write a balanced alternative.",
                "body": "",
            },
            {
                "id": "breathing",
                "title": "Grounding Breath",
                "snippet": "Inhale for 4, hold for 4, exhale for 6. Repeat for one minute to settle the nervous system.",
                "body": "",
            },
            {
                "id": "behavioral_activation",
                "title": "Behavioral Activation",
                "snippet": "Schedule one small valued activity today — motion can gently shift mood.",
                "body": "",
            },
        ]

    def retrieve(self, query: str, k: int = 3) -> list[dict[str, str]]:
        tokens = set(re.findall(r"[a-zA-Z]{3,}", query.lower()))
        scored: list[tuple[int, dict[str, str]]] = []
        for doc in self._docs:
            hay = (doc["title"] + " " + doc["snippet"] + " " + doc.get("body", "")).lower()
            score = sum(1 for t in tokens if t in hay)
            scored.append((score, doc))
        scored.sort(key=lambda x: x[0], reverse=True)
        top = [d for s, d in scored[:k] if s > 0]
        return top or self._docs[:k]
