from __future__ import annotations

from typing import Any, Iterator, TypedDict

try:
    from langgraph.graph import END, StateGraph
except ImportError:  # graceful offline fallback
    StateGraph = None  # type: ignore
    END = None  # type: ignore


class AgentState(TypedDict, total=False):
    message: str
    mode: str
    language: str
    use_personalization: bool
    history: list[dict[str, Any]]
    journal_snippets: list[str]
    retrieved_docs: list[dict[str, str]]
    draft: str


MODE_PROMPTS = {
    "generalSupport": (
        "Respond as FreeMind — a calm, non-judgmental wellness companion. "
        "Validate feelings, keep answers warm and concise, and invite one gentle next step. "
        "You are not a therapist; encourage professional help when distress is intense."
    ),
    "reframeThought": (
        "Help the user gently reframe an unhelpful thought using CBT skills. "
        "Name the thought pattern softly, offer a balanced alternative, and ask one clarifying question."
    ),
    "situationSolver": (
        "Help the user unpack a specific situation. Clarify facts vs. stories, "
        "list what is in their control, and propose 1–3 concrete kind actions."
    ),
}


def _compose_reply(state: AgentState) -> str:
    mode = state.get("mode", "generalSupport")
    language = state.get("language", "English")
    message = state.get("message", "")
    docs = state.get("retrieved_docs") or []
    journals = state.get("journal_snippets") or []
    personalize = state.get("use_personalization", True)

    opener = MODE_PROMPTS.get(mode, MODE_PROMPTS["generalSupport"])
    knowledge = ""
    if docs:
        knowledge = " Drawing on: " + "; ".join(d.get("snippet", "")[:120] for d in docs[:2]) + "."

    memory = ""
    if personalize and journals:
        memory = " I remember themes from your journal and will honor that context gently."

    lang = "" if language == "English" else f" Continue in {language}."

    return (
        f"{opener.split('.')[0]}. I hear you about: “{message[:180]}”."
        f"{knowledge}{memory} "
        "Take one slow breath. You don't have to solve everything now. "
        "What feels most important to focus on next?"
        f"{lang}"
    )


def generate_node(state: AgentState) -> AgentState:
    return {**state, "draft": _compose_reply(state)}


def build_graph():
    if StateGraph is None:
        return None
    graph = StateGraph(AgentState)
    graph.add_node("generate", generate_node)
    graph.set_entry_point("generate")
    graph.add_edge("generate", END)
    return graph.compile()


_GRAPH = build_graph()


def stream_chat_tokens(
    *,
    message: str,
    mode: str,
    language: str,
    use_personalization: bool,
    history: list[dict[str, Any]],
    journal_snippets: list[str],
    retrieved_docs: list[dict[str, str]],
) -> Iterator[str]:
    state: AgentState = {
        "message": message,
        "mode": mode,
        "language": language,
        "use_personalization": use_personalization,
        "history": history,
        "journal_snippets": journal_snippets,
        "retrieved_docs": retrieved_docs,
    }

    if _GRAPH is not None:
        result = _GRAPH.invoke(state)
        text = result.get("draft") or _compose_reply(state)
    else:
        text = _compose_reply(state)

    for word in text.split(" "):
        yield word + " "
