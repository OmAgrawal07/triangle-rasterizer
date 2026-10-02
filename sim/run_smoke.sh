#!/usr/bin/env bash
# Phase 0 smoke: elaborate + run clock/reset TB with Icarus Verilog.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT_DIR="${ROOT}/sim/out"
mkdir -p "${OUT_DIR}"

SOURCES=(
  "${ROOT}/rtl/pkg_raster_params.sv"
  "${ROOT}/rtl/edge_function.sv"
  "${ROOT}/rtl/inside_test.sv"
  "${ROOT}/rtl/framebuffer.sv"
  "${ROOT}/rtl/triangle_regs.sv"
  "${ROOT}/rtl/pixel_scanner.sv"
  "${ROOT}/rtl/raster_top.sv"
  "${ROOT}/tb/tb_raster_smoke.sv"
)

echo "[run_smoke] compiling with iverilog -g2012 ..."
iverilog -g2012 -o "${OUT_DIR}/tb_raster_smoke.vvp" "${SOURCES[@]}"

echo "[run_smoke] running ..."
vvp "${OUT_DIR}/tb_raster_smoke.vvp"

echo "[run_smoke] done."
