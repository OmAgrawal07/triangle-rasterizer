// pixel_scanner.sv — Phase 0 FSM shell only.
// TODO(Om): implement real transitions and pixel walk. Named states only for now.
// Owner: Om. Assistant must not fill the scan algorithm.
// Note: is_inside — "inside" is a SystemVerilog keyword.

module pixel_scanner (
  input  logic                                              clk,
  input  logic                                              rst_n,

  input  logic                                              start,
  output logic                                              busy,
  output logic                                              done,

  output logic [$clog2(pkg_raster_params::WIDTH)-1:0]       x,
  output logic [$clog2(pkg_raster_params::HEIGHT)-1:0]      y,

  input  logic                                              is_inside,
  input  logic [pkg_raster_params::COLOR_WIDTH-1:0]         tri_color,

  output logic                                              clear_en,
  output logic [pkg_raster_params::FB_ADDR_WIDTH-1:0]       clear_addr,
  output logic                                              fb_we,
  output logic [pkg_raster_params::FB_ADDR_WIDTH-1:0]       fb_waddr,
  output logic [pkg_raster_params::COLOR_WIDTH-1:0]         fb_wdata
);

  typedef enum logic [2:0] {
    S_IDLE  = 3'd0,
    S_CLEAR = 3'd1,
    S_LOAD  = 3'd2,
    S_SCAN  = 3'd3,
    S_WRITE = 3'd4,
    S_DONE  = 3'd5
  } state_e;

  // Kept for Om's Phase 1 FSM — unused in Phase 0 stub body.
  /* verilator lint_off UNUSEDSIGNAL */
  state_e state;
  state_e state_n;
  /* verilator lint_on UNUSEDSIGNAL */

  // TODO(Om): always_ff state register with reset → S_IDLE.
  // TODO(Om): always_comb next-state: IDLE --start--> CLEAR/LOAD → SCAN → DONE → IDLE.
  // TODO(Om): Advance x,y across the frame (or bbox); assert fb_we when is_inside.
  // TODO(Om): addr = y * WIDTH + x; pack color per rules sheet.
  // TODO(Om): Pulse done for one cycle; hold busy while not idle.
  // No real transitions in Phase 0 — stay idle so smoke TB only checks clk/rst.

  assign state   = S_IDLE;
  assign state_n = S_IDLE;

  assign busy       = 1'b0;
  assign done       = 1'b0;
  assign x          = '0;
  assign y          = '0;
  assign clear_en   = 1'b0;
  assign clear_addr = '0;
  assign fb_we      = 1'b0;
  assign fb_waddr   = '0;
  assign fb_wdata   = '0;

  logic unused;
  assign unused = clk ^ rst_n ^ start ^ is_inside ^ tri_color[0];

endmodule
