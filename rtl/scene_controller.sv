// scene_controller.sv — Phase 2 multi-triangle sequencer (Om owns).
// Clear once per frame, then for each ROM triangle: load regs → start scan → wait done.
// Painter's algorithm: later index overwrites earlier where they overlap.

module scene_controller (
  input  logic clk,
  input  logic rst_n,

  // Frame handshake (TB / higher level)
  input  logic frame_start,
  output logic frame_busy,
  output logic frame_done,   // 1-cycle pulse when all triangles finished

  // To triangle_rom
  output logic [pkg_raster_params::TRI_IDX_WIDTH-1:0] tri_idx,

  // From / to triangle path (wired in raster_scene_top)
  output logic tri_load,
  output logic scan_start,
  output logic do_clear,     // 1 only for first triangle / clear phase — see TODOs
  input  logic scan_busy,
  input  logic scan_done
);

  import pkg_raster_params::*;

  typedef enum logic [2:0] {
    F_IDLE   = 3'd0,
    F_CLEAR  = 3'd1,  // optional if clear is folded into first scan with do_clear
    F_LOAD   = 3'd2,
    F_SCAN   = 3'd3,
    F_NEXT   = 3'd4,
    F_DONE   = 3'd5
  } frame_state_e;

  frame_state_e state, next_state;

  // TODO(Om): always_ff for state + tri_idx (+ any wait flags).
  // TODO(Om): always_comb next_state:
  //   F_IDLE  --frame_start--> F_LOAD (or F_CLEAR first)
  //   F_LOAD  : pulse tri_load, capture ROM[tri_idx] into triangle_regs (1+ cycles)
  //   F_SCAN  : pulse scan_start with do_clear=(tri_idx==0); wait scan_done
  //   F_NEXT  : tri_idx++; if last → F_DONE else → F_LOAD
  //   F_DONE  : pulse frame_done → F_IDLE
  // TODO(Om): frame_busy = (state != F_IDLE)
  // TODO(Om): Do NOT clear between triangles — only before the first scan.

  always_ff @(posedge clk, negedge rst_n)
    if (~rst_n) begin
      state    <= F_IDLE;
      tri_idx  <= '0;
    end
    else begin
      state    <= next_state;
      if (state == F_IDLE)
        tri_idx <= '0;
      else if (state == F_NEXT)
        tri_idx <= tri_idx + 1'b1;
    end

  always_comb begin
    unique case (state)
      F_IDLE: next_state = frame_state_e'(frame_start ? F_LOAD : F_IDLE);
      F_LOAD: next_state = F_SCAN;
      F_SCAN: next_state = F_CLEAR;
      F_CLEAR: next_state = frame_state_e'(scan_done ? F_NEXT : F_CLEAR);
      F_NEXT: next_state = frame_state_e'((tri_idx == NUM_TRIANGLES-1) ? F_DONE : F_LOAD);
      F_DONE: next_state = F_IDLE;
      default: next_state = F_IDLE;
    endcase
  end

  assign frame_busy  = (state != F_IDLE);
  assign frame_done  = (state == F_DONE);
  assign tri_load    = (state == F_LOAD);
  assign scan_start  = (state == F_SCAN);
  assign do_clear    = (tri_idx == '0);

endmodule
