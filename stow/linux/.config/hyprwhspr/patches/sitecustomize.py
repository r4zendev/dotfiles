import sys
import json
import urllib.request

LLM_URL = "http://localhost:8012/v1/chat/completions"
SYSTEM_PROMPT = (
    "You rewrite raw speech-to-text into clean typed text. "
    "Output ONLY the rewritten text, nothing else.\n"
    "- all lowercase, never capitalize anything\n"
    "- use commas where grammatically natural\n"
    "- no periods, end sentences with newlines instead\n"
    "- remove filler words (um, uh, like, you know, so, oh)\n"
    "- if the speaker corrects themselves or changes their mind, "
    "only keep the final intended message\n"
    "- preserve the speaker's casual tone, don't formalize\n"
    "- never add commentary, explanations, or markdown"
)


def _llm_clean(text):
    try:
        body = json.dumps({
            "model": "qwen2.5-coder",
            "messages": [
                {"role": "system", "content": SYSTEM_PROMPT},
                {"role": "user", "content": text},
            ],
            "temperature": 0,
            "max_tokens": 512,
        }).encode()
        req = urllib.request.Request(
            LLM_URL, data=body,
            headers={"Content-Type": "application/json"}, method="POST",
        )
        with urllib.request.urlopen(req, timeout=5) as resp:
            result = json.loads(resp.read())
            cleaned = result["choices"][0]["message"]["content"].strip()
            if cleaned:
                print(f"[LLM] '{text}' -> '{cleaned}'", flush=True)
                return cleaned
    except Exception as e:
        print(f"[LLM] Post-processing failed, using raw text: {e}", flush=True)
    return text


_original_import = __builtins__.__import__ if hasattr(__builtins__, '__import__') else __import__


def _patching_import(name, *args, **kwargs):
    mod = _original_import(name, *args, **kwargs)
    if name == "text_injector" and hasattr(mod, "TextInjector"):
        orig = mod.TextInjector._preprocess_text
        if not getattr(orig, "_llm_patched", False):
            def _patched(self, text, _orig=orig):
                processed = _orig(self, text)
                return _llm_clean(processed)
            _patched._llm_patched = True
            mod.TextInjector._preprocess_text = _patched
            print("[LLM] Post-processing patch applied", flush=True)
    return mod


try:
    __builtins__.__import__ = _patching_import
except AttributeError:
    import builtins
    builtins.__import__ = _patching_import
