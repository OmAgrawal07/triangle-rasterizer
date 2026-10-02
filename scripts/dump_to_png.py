#!/usr/bin/env python3
"""Phase 0 stub: dump a raw framebuffer dump to PNG.

Later phases: read a binary/hex dump (addr + RGB888), write an image of
size WIDTH×HEIGHT. Depends on docs/rules-sheet.md packing.

Usage (future):
  python3 scripts/dump_to_png.py <dump.bin> <out.png> [--width 64] [--height 64]
"""

from __future__ import annotations

import argparse
import sys


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("dump", nargs="?", help="Raw framebuffer dump path")
    parser.add_argument("out_png", nargs="?", help="Output PNG path")
    parser.add_argument("--width", type=int, default=64)
    parser.add_argument("--height", type=int, default=64)
    args = parser.parse_args()

    # TODO(Phase1+): parse dump, pack RGB888 rows, write PNG (e.g. via Pillow).
    print(
        "dump_to_png.py: Phase 0 stub — not implemented yet.",
        file=sys.stderr,
    )
    print(
        f"Would convert {args.dump!r} -> {args.out_png!r} "
        f"at {args.width}x{args.height}.",
        file=sys.stderr,
    )
    return 1


if __name__ == "__main__":
    raise SystemExit(main())
