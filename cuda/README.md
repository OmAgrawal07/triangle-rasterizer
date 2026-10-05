# CUDA golden rasterizer (software twin)

This directory is a **CUDA/CPU golden model** of the same fill algorithm as the SystemVerilog rasterizer. It is **not** “hardware that uses CUDA.”

Resume-friendly framing:

> Wrote a CUDA golden rasterizer (Q10.6 edge functions) and checked RTL framebuffer output against it.

## Contract (must match RTL)

Locked in [`docs/rules-sheet.md`](../docs/rules-sheet.md) / `rtl/`:

| Rule | Value |
|---|---|
| Fixed-point | signed Q10.6 (`FRAC_BITS=6`) |
| Pixel sample | `(x+0.5, y+0.5)` → `(x<<6)+32` |
| Vertex encoding | integer pixel `<< 6` (no half-pixel on corners) |
| Edge | `E_AB(P) = (Px-Ax)*(By-Ay) - (Py-Ay)*(Bx-Ax)` |
| Inside | `E0>=0 && E1>=0 && E2>=0` (on-edge counts) |
| Winding | CCW; CW/degenerate → empty |
| Overlap | painter overwrite, ROM order |
| Clear | `0x202020` once before first triangle |

## Build

```bash
cd cuda
make              # CPU binary (no GPU needed)
make golden_cuda  # requires nvcc + CUDA toolkit
```

## Render

```bash
# Robot scene (Phase 3 ROM twin)
./bin/golden_cpu --scene robot --backend cpu --out out/robot_cpu.rgb
python3 ../scripts/dump_to_png.py out/robot_cpu.rgb out/robot_cpu.png --width 128 --height 128

# On a CUDA machine
./bin/golden_cuda --scene robot --backend cuda --out out/robot_cuda.rgb
./bin/golden_cuda --scene robot --backend cuda --out out/robot_cuda.rgb \
  --compare out/robot_cpu.rgb
```

Scenes: `phase1` (one triangle), `phase2` (two-triangle overlap @ 64×64), `robot` / `phase3` (66 tris @ 128×128).

## Diff against RTL

```bash
./sim/run_scene.sh                          # writes sim/out/scene.rgb
cd cuda && make compare_rtl_robot           # expects 100% pixel match
```

Or:

```bash
./bin/golden_cpu --scene robot --out out/robot_cpu.rgb --compare ../sim/out/scene.rgb
```

## Layout

```
cuda/
  include/   # params, edge math, scenes API
  src/       # CPU path, CUDA kernels, I/O, CLI
  Makefile
  out/       # generated .rgb / .png (gitignored)
```
