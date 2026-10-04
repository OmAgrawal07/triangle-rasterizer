# Project 2 — Hardware Triangle Rasterizer Rules Sheet

**Owner: Om — locked defaults for Phase 1 (assistant filled from agreed defaults).**

This sheet is the single source of truth for algorithm choices. Keep RTL and any golden model aligned with whatever is written here.

---

## Image size

- Suggested default: **64×64**
- WIDTH = 64
- HEIGHT = 64
- Notes: Phase 1 size. May bump to 128×128 later for character demo (re-author verts).

---

## Fixed-point Q-format

- Suggested default: **Q10.6** (signed, 10 integer bits + 6 fractional bits) or **Q12.4**
- Chosen format: **Q10.6**
- Total bit width (including sign): **16**
- Fractional bits (`FRAC_BITS`): **6**
- How screen coordinates are represented: integer pixel coords shifted left by FRAC_BITS, then add half-pixel for centers; edge math uses signed Q10.6
- Notes / overflow assumptions: widen multiply results (≈ 2×COORD_WIDTH+1 bits) before using the sign; screen coords 0..63 fit easily in Q10.6

---

## Pixel centers at (x+0.5, y+0.5)

- Confirm: sample each integer pixel `(x, y)` at its **center** `(x + 0.5, y + 0.5)` in fixed-point. **YES**
- Fixed-point encoding of `0.5` (e.g. `1 << (FRAC_BITS-1)`): **`1 << 5` = 32** (`HALF_PIXEL` in pkg)
- Notes: `P = (x << 6) + 32`, same for y

---

## CCW winding

- Confirm: triangles are wound **counter-clockwise (CCW)** in screen space. **YES**
- Vertex order convention (v0 → v1 → v2): **CCW in screen space (x right, y down)**
- What to do with CW / degenerate input (reject, flip, undefined): **treat as empty fill (no pixels); do not auto-flip**
- Notes: blank PNG → check winding first

---

## Edge-function formula

- For edge from `A=(Ax,Ay)` to `B=(Bx,By)` and sample point `P=(Px,Py)`, write the exact formula you will implement:

  ```
  E_AB(P) = (Px - Ax) * (By - Ay) - (Py - Ay) * (Bx - Ax)
  ```

- Edge0 (v0→v1), Edge1 (v1→v2), Edge2 (v2→v0) definitions:
  - **E0 = E(v0 → v1, P)**
  - **E1 = E(v1 → v2, P)**
  - **E2 = E(v2 → v0, P)**
- Signedness / bit-growth notes: signed; keep full product width for the compare; only the sign / ≥0 matters for coverage

---

## Inside = all three edges satisfy the chosen inequality

- Inside predicate (circle one / write exact):

  - `E0 >= 0 && E1 >= 0 && E2 >= 0`

- Chosen inequality: **`>=`**
- Tie-breaking / top-left rule (if any): **none — on-edge counts as inside**
- Notes: matches CCW + painter’s overwrite

---

## Framebuffer addr = y*WIDTH+x + RGB packing

- Address formula: `addr = y * WIDTH + x`
- Color bit width: **24**
- RGB packing (bit ranges for R, G, B):

  | Channel | Bits    |
  |---------| | ------- |
  | R       | [23:16] |
  | G       | [15:8]  |
  | B       | [7:0]   |

- Clear / background color value: **`24'h202020`** (dark gray; change if you want)
- Notes: matches `pkg_raster_params` / current top clear color

---

## Painter’s algorithm overlaps

- Confirm: later triangles **overwrite** earlier ones (no z-buffer in Phase 0+ core path unless noted). **YES**
- Draw order contract (who sorts triangles): **scene author / triangle list order — Om orders back-to-front in the ROM**
- Notes: no z-buffer on main path
