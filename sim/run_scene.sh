#!/usr/bin/env bash
# Phase 2: multi-triangle scene elaborate / run (Icarus).
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

echo "[run_scene] running ..."
vvp "${OUT_DIR}/tb_raster_scene.vvp"

echo "[run_scene] done."
echo "[run_scene] After Om implements ROM+controller: dump scene.rgb and run dump_to_png.py"
