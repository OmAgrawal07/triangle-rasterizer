# Always-`ff` tips (Project 2)

Short habits that keep SystemVerilog RTL synthesizable and reviewable.

## Prefer `always_ff` for state

- Use `always_ff @(posedge clk or negedge rst_n)` (or your project’s reset style) for **registers and FSM state**.
- Put combinational next-state / datapath in `always_comb` or continuous `assign`, not in the `ff` block.

## Reset cleanly

- Reset **every** register you care about (state, counters, busy/done, latched vertices).
- Pick one reset polarity project-wide (`rst_n` active-low is fine) and stick to it.

## One job per block

- Do not mix “compute edge value”, “update pixel counters”, and “write framebuffer” in one giant `always_ff`.
- Keep edge math and inside-test as separate modules; the scanner should only sequence them.

## Nonblocking in `ff`, blocking in `comb`

- `<=` inside `always_ff`
- `=` inside `always_comb`
- Mixing styles is a common source of simulation/synthesis mismatch.

## Named FSM states

- Use an `enum` (or `localparam`s) for states: `S_IDLE`, `S_LOAD`, `S_SCAN`, `S_DONE`, etc.
- Default branch in the next-state `case` should recover to a safe state (usually `S_IDLE`).

## Handshake hygiene

- Document `start` / `busy` / `done` timing (e.g. pulse `start` for one cycle while `!busy`; `done` asserts for one cycle when finished).
- Do not accept a new triangle while `busy` is high unless the design explicitly queues.

## Fixed-point gotchas

- Keep Q-format identical across edge math, pixel centers (`+0.5`), and golden model.
- Watch bit growth on multiplies; widen intermediates before truncating.

## Framebuffer writes

- One write per cycle is enough for the Phase-0 scanner.
- Address with `y * WIDTH + x`; pack RGB exactly as the rules sheet says.
