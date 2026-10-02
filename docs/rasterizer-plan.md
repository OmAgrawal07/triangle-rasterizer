// Hardware Triangle Rasterizer — Project Plan
// For: Om Agrawal (CMU ECE sophomore)
// Stack: SystemVerilog (main work) + thin Python harness (PNG / bit-exact compare)
// Demo goal: Real PNG images from hardware → recognizable low-poly character/object
//
 // NOTE: This plan may be deleted when the project is fully complete.

# Hardware Triangle Rasterizer — Project Plan

## 1. What this project is

Build the **fill** step of a tiny graphics pipeline in hardware: given a triangle’s three corners and a color, decide which pixels are inside and paint them into a frame buffer, then dump that buffer as a real PNG.

| Everyday idea | Hardware piece |
|---|---|
| Blank canvas of pixels | Frame buffer |
| “Is this point inside?” | Edge-function combinational logic |
| Walk the canvas and paint | Pixel-scan FSM |
| Save the drawing | Dump → thin Python PNG writer |
| Character from flat faces | Scene: list of triangles + colors |

**Not:** AI image gen, a full GPU, or a “port Python rasterizer to SV” homework. Python is verification glue only.

## 2. What you will learn

- Combinational math (edge functions, fixed-point compares)
- Sequential `always_ff` FSM scanning pixels / triangles
- Framebuffer memory: `addr = f(x,y)`, write when inside
- Parameterized modules; testbenches; waveform + visual + late golden checks

## 3. SV-first development rule (non-negotiable)

| Layer | Role |
|---|---|
| SystemVerilog | The project (edge math, FSM, FB, scene, TB) |
| Python | Dump → PNG; optional bit-exact golden |
| Paper / chat math | Tiny worked examples — not a software rasterizer |

**Anti-pattern:** Do not polish a Python rasterizer for weeks then “port later.”

**Flow:** rules sheet → SV implement → RTL smoke → late thin Python golden that mirrors the sheet.

## 4. Ownership

**Om owns:** `edge_function`, `inside_test`, pixel-scan FSM, FB write path integration, multi-triangle sequencer, scene data, primary TBs, locking the rules sheet.

**Assistant owns:** starter patterns / tip sheets, FB memory skeleton, top wiring / sim stubs, thin Python PNG harness, chalk-talks, optional stretch stubs.

## 5. Algorithm conventions (rules sheet)

Suggested defaults: 64×64 (phase 1), Q10.6 or Q12.4, sample at `(x+0.5, y+0.5)`, CCW winding, `inside = e0>=0 && e1>=0 && e2>=0`, `addr = y*WIDTH+x`, painter’s overwrite.

See `docs/rules-sheet.md` (Om fills and locks).

## 6. Module map

| Module | Owner |
|---|---|
| `edge_function` | Om |
| `inside_test` | Om |
| `pixel_scanner` | Om |
| `framebuffer` | Skeleton OK from assistant |
| `triangle_regs` | Om |
| `scene_controller` / ROM | Om (phase 2+) |
| `raster_top` | Shared glue |
| `tb_raster_*` | Om primary |
| `dump_to_png.py` | Assistant |

## 7. Phases

- **Phase 0** — Spec lock & repo skeleton (this PR): rules template, empty shells, smoke elaborate
- **Phase 1** — One triangle → real PNG
- **Phase 2** — Multi-triangle scene, painter’s order
- **Phase 3** — Recognizable low-poly character (main demo)
- **Phase 4** — Optional stretches (depth, shading, barycentric, larger res, FPGA)

## 8–12. Build order, testing, tooling, risks

Build SV-first checklist in plan §8. Testing by phase: elaborate → waveforms + PNG → optional golden. Pick one simulator early (this repo: **Icarus Verilog**). Mitigate blank PNG via hand-tested points; timebox Python; stay ≤128² for sim.

## Success bars

- **Minimum:** Phase 1 PNG + locked rules sheet + explainable `inside_test`
- **Project success:** Phase 3 recognizable character from multi-triangle SV
- **Stretch:** Phase 3 + one visible stretch

## Mentoring cadence / out of scope

Reviews after each phase; assistant suggests hypotheses when blocked; Om edits RTL. Out of scope: full vertex shaders, texturing, GPU buses, discovering the fill algorithm in Python.
