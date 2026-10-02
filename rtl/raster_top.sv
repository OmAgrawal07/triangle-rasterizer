// raster_top.sv — Phase 0 wiring glue (shared).
// Wires Om-owned shells + framebuffer. start/busy/done are stubs until Phase 1.
// How to change: once triangle_regs / pixel_scanner are real, TB drives
//   vertices + start; dump via fb_raddr/fb_rdata after done.

module raster_top (
  input  logic                                              clk,
  input  logic                                              rst_n,

  input  logic                                              start,
  output logic                                              busy,
  output logic                                              done,

  input  logic                                              tri_load,
  input  logic signed [pkg_raster_params::COORD_WIDTH-1:0]  v0_x,
  input  logic signed [pkg_raster_params::COORD_WIDTH-1:0]  v0_y,
  input  logic signed [pkg_raster_params::COORD_WIDTH-1:0]  v1_x,
  input  logic signed [pkg_raster_params::COORD_WIDTH-1:0]  v1_y,
  input  logic signed [pkg_raster_params::COORD_WIDTH-1:0]  v2_x,
  input  logic signed [pkg_raster_params::COORD_WIDTH-1:0]  v2_y,
  input  logic        [pkg_raster_params::COLOR_WIDTH-1:0]  tri_color,

  input  logic [pkg_raster_params::FB_ADDR_WIDTH-1:0]       fb_raddr,
  output logic [pkg_raster_params::COLOR_WIDTH-1:0]         fb_rdata
);

  import pkg_raster_params::*;

  logic signed [COORD_WIDTH-1:0] r_v0_x, r_v0_y, r_v1_x, r_v1_y, r_v2_x, r_v2_y;
  logic        [COLOR_WIDTH-1:0] r_color;

  triangle_regs u_tri_regs (
    .clk(clk),
    .rst_n(rst_n),
    .load(tri_load),
    .v0_x_i(v0_x),
    .v0_y_i(v0_y),
    .v1_x_i(v1_x),
    .v1_y_i(v1_y),
    .v2_x_i(v2_x),
    .v2_y_i(v2_y),
    .color_i(tri_color),
    .v0_x(r_v0_x),
    .v0_y(r_v0_y),
    .v1_x(r_v1_x),
    .v1_y(r_v1_y),
    .v2_x(r_v2_x),
    .v2_y(r_v2_y),
    .color(r_color)
  );

  logic [$clog2(WIDTH)-1:0]  pix_x;
  logic [$clog2(HEIGHT)-1:0] pix_y;
  logic                      is_inside;
  logic                      clear_en;
  logic [FB_ADDR_WIDTH-1:0]  clear_addr;
  logic                      fb_we;
  logic [FB_ADDR_WIDTH-1:0]  fb_waddr;
  logic [COLOR_WIDTH-1:0]    fb_wdata;

  // Sample point in fixed-point: integer pixel + half-pixel (rules sheet).
  // Phase 0: placeholder wiring so edge_function ports are connected.
  // TODO(Om): convert {pix_x, pix_y} to Q-format centers (x+0.5, y+0.5)
  //           using FRAC_BITS / HALF_PIXEL from pkg_raster_params — match rules sheet.
  logic signed [COORD_WIDTH-1:0] px_q, py_q;
  assign px_q = HALF_PIXEL;
  assign py_q = HALF_PIXEL;

  logic signed [2*COORD_WIDTH:0] e0, e1, e2;

  // Edge0: V0→V1, Edge1: V1→V2, Edge2: V2→V0  (confirm on rules sheet)
  edge_function u_e0 (
    .ax(r_v0_x), .ay(r_v0_y),
    .bx(r_v1_x), .by(r_v1_y),
    .px(px_q),   .py(py_q),
    .e(e0)
  );
  edge_function u_e1 (
    .ax(r_v1_x), .ay(r_v1_y),
    .bx(r_v2_x), .by(r_v2_y),
    .px(px_q),   .py(py_q),
    .e(e1)
  );
  edge_function u_e2 (
    .ax(r_v2_x), .ay(r_v2_y),
    .bx(r_v0_x), .by(r_v0_y),
    .px(px_q),   .py(py_q),
    .e(e2)
  );

  inside_test u_inside (
    .e0(e0),
    .e1(e1),
    .e2(e2),
    .is_inside(is_inside)
  );

  pixel_scanner u_scan (
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .busy(busy),
    .done(done),
    .x(pix_x),
    .y(pix_y),
    .is_inside(is_inside),
    .tri_color(r_color),
    .clear_en(clear_en),
    .clear_addr(clear_addr),
    .fb_we(fb_we),
    .fb_waddr(fb_waddr),
    .fb_wdata(fb_wdata)
  );

  framebuffer u_fb (
    .clk(clk),
    .rst_n(rst_n),
    .clear_en(clear_en),
    .clear_addr(clear_addr),
    .clear_color(24'h202020),
    .we(fb_we),
    .waddr(fb_waddr),
    .wdata(fb_wdata),
    .raddr(fb_raddr),
    .rdata(fb_rdata)
  );

endmodule
