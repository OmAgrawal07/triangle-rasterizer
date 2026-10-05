// pixel_scanner.sv — Phase 0 FSM shell only.
// Owner: Om.
// Note: is_inside — "inside" is a SystemVerilog keyword.

module pixel_scanner (
  input  logic                                              clk,
  input  logic                                              rst_n,

  input  logic                                              start,
  // TODO(Om Phase 2): when 1, IDLE→CLEAR→SCAN; when 0, IDLE→SCAN (skip clear).
  // For Phase 1 / default, tie this to 1'b1 so behavior stays clear-then-scan.
  input  logic                                              do_clear,
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

  // Creating a Moore FSM for the pixel scanner (outputs depend strictly on state)
  // One output (fb_we) depends on input is_inside, following Mealy FSM convention

  import pkg_raster_params::*;
  
  typedef enum logic [2:0] {
    S_IDLE  = 3'd0,
    S_CLEAR = 3'd1,
    S_LOAD  = 3'd2,
    S_SCAN  = 3'd3,
    S_WRITE = 3'd4,
    S_DONE  = 3'd5
  } state_e;

  /* verilator lint_off UNUSEDSIGNAL */
  state_e state;
  state_e nextState;
  /* verilator lint_on UNUSEDSIGNAL */

  // TODO(Om Phase 2): use do_clear in next-state from S_IDLE:
  //   start && do_clear  → S_CLEAR
  //   start && !do_clear → S_SCAN
  // Until then Phase 1 keeps always going to S_CLEAR on start.

  logic unused_do_clear;
  assign unused_do_clear = do_clear;

  always_ff @(posedge clk, negedge rst_n)
    if (~rst_n) begin
      state <= S_IDLE;
      x <= '0;
      y <= '0;
      clear_addr <= '0;
    end
    else begin
      state <= nextState;
      if (state == S_IDLE) begin
        x <= '0;
        y <= '0;
        clear_addr <= '0;
      end
      else if (state == S_CLEAR)
        clear_addr <= clear_addr + 1;
      else if (state == S_SCAN) begin
        if (x < WIDTH-1)
          x <= x + 1;
        else begin
          x <= '0;
          y <= y + 1;
        end
      end
    end

  assign done = (state == S_DONE);

  logic scan_done;
  assign scan_done = (x == WIDTH-1) && (y == HEIGHT-1);

  always_comb begin
    unique case (state)
      S_IDLE: nextState = state_e'(!start ? S_IDLE : 
                                  do_clear ? S_CLEAR : S_SCAN);
      S_CLEAR: nextState = state_e'(clear_addr == FB_DEPTH-1 ? S_SCAN : S_CLEAR);
      S_SCAN: nextState = state_e'(scan_done ? S_DONE : S_SCAN);
      S_DONE: nextState = S_IDLE;
      default: nextState = S_IDLE;
    endcase
  end

  // Outputs only assigned here
  assign busy       = (state != S_IDLE);
  assign clear_en   = (state == S_CLEAR);
  assign fb_we      = (state == S_SCAN) && is_inside;
  assign fb_waddr   = y * WIDTH + x;
  assign fb_wdata   = tri_color;

endmodule