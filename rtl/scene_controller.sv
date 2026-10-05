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

  assign state       = F_IDLE;
  assign next_state  = F_IDLE;
  assign tri_idx     = '0;
  assign tri_load    = 1'b0;
  assign scan_start  = 1'b0;
  assign do_clear    = 1'b0;
  assign frame_busy  = 1'b0;
  assign frame_done  = 1'b0;

  logic unused;
  assign unused = clk ^ rst_n ^ frame_start ^ scan_busy ^ scan_done;

endmodule
