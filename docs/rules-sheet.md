# Project 2 — Hardware Triangle Rasterizer Rules Sheet

**Owner: Om — fill every section before implementing edge math / FSM.**

This sheet is the single source of truth for algorithm choices. Keep RTL and the C++ golden model aligned with whatever you write here.

---

## Image size

- Suggested default: **64×64**
- WIDTH =
- HEIGHT =
- Notes:

---

## Fixed-point Q-format

- Suggested default: **Q10.6** (signed, 10 integer bits + 6 fractional bits) or **Q12.4**
- Chosen format:
- Total bit width (including sign):
- Fractional bits (`FRAC_BITS`):
- How screen coordinates are represented:
- Notes / overflow assumptions:

---

## Pixel centers at (x+0.5, y+0.5)

- Confirm: sample each integer pixel `(x, y)` at its **center** `(x + 0.5, y + 0.5)` in fixed-point.
- Fixed-point encoding of `0.5` (e.g. `1 << (FRAC_BITS-1)`):
- Notes:

---

## CCW winding

- Confirm: triangles are wound **counter-clockwise (CCW)** in screen space.
- Vertex order convention (v0 → v1 → v2):
- What to do with CW / degenerate input (reject, flip, undefined):
- Notes:

---

## Edge-function formula

- For edge from `A=(Ax,Ay)` to `B=(Bx,By)` and sample point `P=(Px,Py)`, write the exact formula you will implement:

  ```
  E_AB(P) = ?
  ```

- Edge0 (v0→v1), Edge1 (v1→v2), Edge2 (v2→v0) definitions:
- Signedness / bit-growth notes:

---

## Inside = all three edges satisfy the chosen inequality

- Inside predicate (circle one / write exact):

  - `E0 ? 0 && E1 ? 0 && E2 ? 0`   where `?` is `>=` or `>`

- Chosen inequality:
- Tie-breaking / top-left rule (if any):
- Notes:

---

## Framebuffer addr = y*WIDTH+x + RGB packing

- Address formula: `addr = y * WIDTH + x`
- Color bit width:
- RGB packing (bit ranges for R, G, B):

  | Channel | Bits |
  |---------| | ---- |
  | R       |      |
  | G       |      |
  | B       |      |

- Clear / background color value:
- Notes:

---

## Painter’s algorithm overlaps

- Confirm: later triangles **overwrite** earlier ones (no z-buffer in Phase 0+ core path unless noted).
- Draw order contract (who sorts triangles):
- Notes:
