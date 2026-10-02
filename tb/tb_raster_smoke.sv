// tb_raster_smoke.sv — Phase 0: clock/reset elaborate + a few cycles only.
// No triangle fill, no PNG. Om extends this in Phase 1.

`timescale 1ns/1ps

module tb_raster_smoke;
  import pkg_raster_params::*;

  logic clk;
  logic rst_n;
  logic start;
  logic busy;
  logic done;

  logic                          tri_load;
  logic signed [COORD_WIDTH-1:0] v0_x, v0_y, v1_x, v1_y, v2_x, v2_y;
  logic        [COLOR_WIDTH-1:0] tri_color;
  logic [FB_ADDR_WIDTH-1:0]      fb_raddr;
  logic [COLOR_WIDTH-1:0]        fb_rdata;

  raster_top dut (
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .busy(busy),
    .done(done),
    .tri_load(tri_load),
    .v0_x(v0_x),
    .v0_y(v0_y),
    .v1_x(v1_x),
    .v1_y(v1_y),
    .v2_x(v2_x),
    .v2_y(v2_y),
    .tri_color(tri_color),
    .fb_raddr(fb_raddr),
    .fb_rdata(fb_rdata)
  );

  initial clk = 1'b0;
  always #5 clk = ~clk;

  initial begin
    rst_n     = 1'b0;
    start     = 1'b0;
    tri_load  = 1'b0;
    v0_x = '0; v0_y = '0;
    v1_x = '0; v1_y = '0;
    v2_x = '0; v2_y = '0;
    tri_color = 24'hFF0000;
    fb_raddr  = '0;

    repeat (4) @(posedge clk);
    rst_n = 1'b1;
    repeat (10) @(posedge clk);

    $display("tb_raster_smoke: PASS (clock/reset smoke; WIDTH=%0d HEIGHT=%0d)",
             WIDTH, HEIGHT);
    $finish;
  end

  initial begin
    #10000;
    $display("tb_raster_smoke: FAIL timeout");
    $fatal(1);
  end

endmodule
