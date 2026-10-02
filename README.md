# triangle-rasterizer

Hardware triangle rasterizer in **SystemVerilog**, with a thin Python harness for PNG export / optional bit-exact compare later.

**Owner:** Om Agrawal (CMU ECE)  
**Demo goal:** Real PNGs from RTL, ending at a recognizable low-poly character/object.

## SV-first rule

SystemVerilog is the design. Python is dump/compare glue only — not where the fill algorithm is invented. Lock conventions in [`docs/rules-sheet.md`](docs/rules-sheet.md) before implementing edge math or the scan FSM.

## Phase 0 status

Repo scaffold only:

- Parameter package + module shells (`TODO(Om)` on edge math / inside-test / triangle regs / pixel FSM)
- Working synchronous `framebuffer`
- Top-level wiring with stubbed `start` / `busy` / `done`
- Clock/reset smoke testbench

**You (Om):** fill and lock `docs/rules-sheet.md` before Phase 1.

## Layout

```
docs/rules-sheet.md      # YOUR spec (fill this)
docs/always-ff-tips.md   # always_ff / FSM hygiene tip sheet
docs/rasterizer-plan.md  # full project plan
rtl/                     # SystemVerilog modules
tb/                      # testbenches
sim/run_smoke.sh         # Icarus Verilog smoke script
scripts/dump_to_png.py   # Phase 0 stub (real harness in Phase 1)
```

## Simulator

**Icarus Verilog** (`iverilog` / `vvp`) with `-g2012`.

```bash
# Install (Debian/Ubuntu)
sudo apt-get install -y iverilog

# Smoke (Phase 0)
chmod +x sim/run_smoke.sh
./sim/run_smoke.sh
```

Expect: elaborate + a few clock cycles, then `tb_raster_smoke: PASS`.

## Ownership cheat-sheet

| Piece | Who |
|---|---|
| Rules sheet, edge_function, inside_test, pixel_scanner, triangle_regs | **Om** |
| framebuffer memory, top glue, sim stubs, PNG harness | Assistant scaffolds |

## Next

1. Fill `docs/rules-sheet.md` (image size, Q-format, centers, CCW, edge formula, inside inequality, FB packing, painter’s overlaps).
2. Phase 1: implement edge + inside + FSM → one triangle PNG.
