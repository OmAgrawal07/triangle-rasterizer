#!/usr/bin/env python3
"""Byte-compare two raw RGB888 framebuffer dumps (RTL vs golden).

Usage:
  python3 scripts/compare_rgb.py sim/out/scene.rgb cuda/out/robot_cpu.rgb \\
      --width 128 --height 128
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("a", type=Path, help="First RGB888 dump")
    parser.add_argument("b", type=Path, help="Second RGB888 dump")
    parser.add_argument("--width", type=int, required=True)
    parser.add_argument("--height", type=int, required=True)
    args = parser.parse_args()

    expected = args.width * args.height * 3
    data_a = args.a.read_bytes()
    data_b = args.b.read_bytes()
    if len(data_a) != expected:
        print(f"error: {args.a} has {len(data_a)} bytes, expected {expected}", file=sys.stderr)
        return 2
    if len(data_b) != expected:
        print(f"error: {args.b} has {len(data_b)} bytes, expected {expected}", file=sys.stderr)
        return 2

    mismatches = 0
    first = None
    for i in range(0, expected, 3):
        if data_a[i : i + 3] != data_b[i : i + 3]:
            if first is None:
                pix = i // 3
                first = (pix % args.width, pix // args.width, data_a[i : i + 3], data_b[i : i + 3])
            mismatches += 1

    total = args.width * args.height
    if mismatches == 0:
        print(f"PASS — {total} pixels match ({args.a} vs {args.b})")
        return 0

    fx, fy, ca, cb = first
    match_rate = 100.0 * (total - mismatches) / total
    print(f"FAIL — {mismatches}/{total} pixels differ ({match_rate:.4f}% match)")
    print(f"  first mismatch at ({fx},{fy}): A={ca.hex()} B={cb.hex()}")
    return 1


if __name__ == "__main__":
    raise SystemExit(main())
