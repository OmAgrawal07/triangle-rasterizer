#!/usr/bin/env bash
# Phase 3: multi-triangle scene → RGB dump → PNG (128×128 robot).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT_DIR="${ROOT}/sim/out"
mkdir -p "${OUT_DIR}"
cd "${ROOT}"

SOURCES=(
  "${ROOT}/rtl/pkg_raster_params.sv"
  "${ROOT}/rtl/edge_function.sv"
  "${ROOT}/rtl/inside_test.sv"
  "${ROOT}/rtl/framebuffer.sv"
  "${ROOT}/rtl/triangle_regs.sv"
  "${ROOT}/rtl/pixel_scanner.sv"
  "${ROOT}/rtl/raster_top.sv"
  "${ROOT}/rtl/triangle_rom.sv"
  "${ROOT}/rtl/scene_controller.sv"
  "${ROOT}/rtl/raster_scene_top.sv"
  "${ROOT}/tb/tb_raster_scene.sv"
)

echo "[run_scene] compiling with iverilog -g2012 ..."
iverilog -g2012 -o "${OUT_DIR}/tb_raster_scene.vvp" "${SOURCES[@]}"

echo "[run_scene] running (128x128, 66 tris — may take a bit) ..."
vvp "${OUT_DIR}/tb_raster_scene.vvp"

echo "[run_scene] converting dump -> PNG ..."
python3 "${ROOT}/scripts/dump_to_png.py" \
  "${OUT_DIR}/scene.rgb" \
  "${OUT_DIR}/scene.png" \
  --width 128 --height 128

echo "[run_scene] done. Open sim/out/scene.png"
