#!/usr/bin/env python3
"""Print the first bindable TCP port at or above a starting port."""

from __future__ import annotations

import argparse
import socket


def find_free_port(host: str, start: int) -> int:
    for port in range(start, 65_536):
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as candidate:
            try:
                candidate.bind((host, port))
            except OSError:
                continue
            return port
    raise RuntimeError(f"No free TCP port found at or above {start}")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--host", default="127.0.0.1")
    parser.add_argument("--start", type=int, default=8000)
    args = parser.parse_args()

    if not 1 <= args.start <= 65_535:
        parser.error("--start must be between 1 and 65535")

    print(find_free_port(args.host, args.start))


if __name__ == "__main__":
    main()
