// framebuffer.sv — simple synchronous memory (assistant-owned skeleton).
// Linear address: addr = y * WIDTH + x (computed by the write path / scanner).
// How to change: adjust COLOR_WIDTH / FB_DEPTH via pkg_raster_params;
//   add a second read port later if dump needs concurrent access.

module framebuffer (
  input  logic                                           clk,
  input  logic                                           rst_n,

  input  logic                                           clear_en,
  input  logic [pkg_raster_params::FB_ADDR_WIDTH-1:0]    clear_addr,
  input  logic [pkg_raster_params::COLOR_WIDTH-1:0]      clear_color,

  input  logic                                           we,
  input  logic [pkg_raster_params::FB_ADDR_WIDTH-1:0]    waddr,
  input  logic [pkg_raster_params::COLOR_WIDTH-1:0]      wdata,

  input  logic [pkg_raster_params::FB_ADDR_WIDTH-1:0]    raddr,
  output logic [pkg_raster_params::COLOR_WIDTH-1:0]      rdata
);

  import pkg_raster_params::*;

  logic [COLOR_WIDTH-1:0] mem [0:FB_DEPTH-1];

  always_ff @(posedge clk) begin
    if (clear_en) begin
      mem[clear_addr] <= clear_color;
    end else if (we) begin
      mem[waddr] <= wdata;
    end
    rdata <= mem[raddr];
  end

  // SRAM contents are cleared by a sweep (clear_en), not by rst_n alone.
  logic unused_rst_n;
  assign unused_rst_n = rst_n;

endmodule
