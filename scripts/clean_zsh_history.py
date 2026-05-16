#!/usr/bin/env python3

import os
import sys
import tempfile


def should_remove(cmd_bytes: bytes) -> bool:
    if len(cmd_bytes.split()) == 1:
        return True

    return False


def main():
    zsh_history = os.path.expanduser("~/.zsh_history")
    if not os.path.isfile(zsh_history):
        print(f"File not found: {zsh_history}", file=sys.stderr)
        return

    count_removed = 0

    with (
        open(zsh_history, "rb") as f,
        tempfile.NamedTemporaryFile(
            "wb",
            delete=False,
            dir=os.path.dirname(zsh_history),
        ) as tmp,
    ):
        for line in f:
            line_stripped = line.strip()
            if not line_stripped:
                count_removed += 1
                continue

            if should_remove(line_stripped):
                count_removed += 1
                continue

            tmp.write(line)

    os.replace(tmp.name, zsh_history)

    print(f"Remove {count_removed} lines from {zsh_history} :D")


if __name__ == "__main__":
    main()
