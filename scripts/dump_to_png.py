#!/usr/bin/env python3
"""Convert a raw RGB888 framebuffer dump to a PNG.

Dump format (from tb_raster_triangle):
  - Binary file, length = width * height * 3
  - Pixel order: addr 0 .. depth-1  (addr = y * width + x)
  - Byte order per pixel: R, G, B  (matches rules-sheet RGB888 packing)

No third-party deps required (stdlib zlib PNG writer).

Usage:
  python3 scripts/dump_to_png.py sim/out/frame.rgb sim/out/triangle.png
  python3 scripts/dump_to_png.py sim/out/frame.rgb out.png --width 64 --height 64
"""

from __future__ import annotations

import argparse
import struct
import sys
import zlib
from pathlib import Path


def write_png_rgb(path: Path, width: int, height: int, rgb: bytes) -> None:
    expected = width * height * 3
    if len(rgb) != expected:
        raise ValueError(
            f"dump has {len(rgb)} bytes, expected {expected} for {width}x{height} RGB888"
        )

    def chunk(tag: bytes, data: bytes) -> bytes:
        return (
            struct.pack(">I", len(data))
            + tag
            + data
            + struct.pack(">I", zlib.crc32(tag + data) & 0xFFFFFFFF)
        )

    # PNG: each row starts with filter byte 0 (None), then RGB samples
    raw = bytearray()
    row_bytes = width * 3
    for y in range(height):
        raw.append(0)
        start = y * row_bytes
        raw.extend(rgb[start : start + row_bytes])

    ihdr = struct.pack(">IIBBBBB", width, height, 8, 2, 0, 0, 0)  # 8-bit truecolor
    png = (
        b"\x89PNG\r\n\x1a\n"
        + chunk(b"IHDR", ihdr)
        + chunk(b"IDAT", zlib.compress(bytes(raw), 9))
        + chunk(b"IEND", b"")
    )
    path.write_bytes(png)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("dump", type=Path, help="Raw RGB888 dump path")
    parser.add_argument("out_png", type=Path, help="Output PNG path")
    parser.add_argument("--width", type=int, default=64)
    parser.add_argument("--height", type=int, default=64)
    args = parser.parse_args()

    if not args.dump.is_file():
        print(f"error: dump not found: {args.dump}", file=sys.stderr)
        return 1

    rgb = args.dump.read_bytes()
    try:
        write_png_rgb(args.out_png, args.width, args.height, rgb)
    except ValueError as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 1

    print(f"wrote {args.out_png} ({args.width}x{args.height})")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
