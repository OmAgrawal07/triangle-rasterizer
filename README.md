# triangle-rasterizer

Hardware triangle rasterizer in **SystemVerilog**, with a thin Python PNG harness and a **CUDA/CPU golden twin** for bit-exact verification.

**Owner:** Om Agrawal (CMU ECE)  
**Demo goal:** Real PNGs from RTL — Phase 3 is a 128×128 low-poly cartoon robot (66 triangles).

## SV-first rule

SystemVerilog is the design. Python is dump/compare glue. The CUDA tree is a **software golden**, not “hardware that uses CUDA.” Lock conventions in [`docs/rules-sheet.md`](docs/rules-sheet.md).

Resume line for the GPU piece:

> Wrote a CUDA golden rasterizer and checked RTL output against it.

## Layout

```
docs/rules-sheet.md   # locked fill rules (Q10.6, CCW, inside, packing)
rtl/                  # SystemVerilog (edge, scan FSM, FB, scene ROM)
tb/                   # testbenches
sim/                  # Icarus run scripts
scripts/              # RGB → PNG, RGB compare
cuda/                 # CUDA/CPU golden twin (same fill rules)
```

## Simulator (RTL)

```bash
sudo apt-get install -y iverilog   # Debian/Ubuntu
./sim/run_smoke.sh                 # elaborate + clock
./sim/run_triangle.sh              # one triangle → sim/out/
./sim/run_scene.sh                 # robot scene → sim/out/scene.png
```

## CUDA / CPU golden

```bash
cd cuda
make                 # CPU binary (no GPU required)
make run_robot       # render robot → cuda/out/robot_cpu.png
make selftest        # identity smoke check

# On a machine with CUDA toolkit:
make golden_cuda
./bin/golden_cuda --scene robot --backend cuda --out out/robot_cuda.rgb \
  --compare out/robot_cpu.rgb

# After RTL sim dump:
./bin/golden_cpu --scene robot --out out/robot_cpu.rgb \
  --compare ../sim/out/scene.rgb
```

See [`cuda/README.md`](cuda/README.md) for the bit-exact contract and CLI.

## Ownership cheat-sheet

| Piece | Who |
|---|---|
| Rules sheet, edge_function, inside_test, pixel_scanner, triangle_regs, scene ROM | **Om** |
| framebuffer, top glue, sim stubs, PNG harness, CUDA golden twin | Assistant scaffolds |
