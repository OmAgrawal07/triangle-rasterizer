`timescale 1ns/1ps

module tb_raster_triangle;
  import pkg_raster_params::*;

  logic clk, rst_n, start, busy, done;

  logic                          tri_load;
  logic signed [COORD_WIDTH-1:0] v0_x, v0_y, v1_x, v1_y, v2_x, v2_y;
  logic        [COLOR_WIDTH-1:0] tri_color;
  logic [FB_ADDR_WIDTH-1:0]      fb_raddr;
  logic [COLOR_WIDTH-1:0]        fb_rdata;

  raster_top dut (.*);

  initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
  end

  initial begin
    rst_n     = 1'b0;
    start     = 1'b0;
    tri_load  = 1'b0;
    fb_raddr  = '0;

    repeat (4) @(posedge clk);
    rst_n = 1'b1;
    repeat (2) @(posedge clk);

    v0_x = 10 <<< FRAC_BITS; v0_y = 10 <<< FRAC_BITS;
    v1_x = 30 <<< FRAC_BITS; v1_y = 40 <<< FRAC_BITS;
    v2_x = 50 <<< FRAC_BITS; v2_y = 10 <<< FRAC_BITS;
    tri_color = 24'h39C6ED;

    @(posedge clk);
    tri_load = 1'b1;
    @(posedge clk);
    tri_load = 1'b0;

    @(posedge clk);
    start = 1'b1;
    @(posedge clk);
    start = 1'b0;

    wait (done);
    @(posedge clk);

    fb_raddr = 30*WIDTH + 30;
    @(posedge clk); @(posedge clk);
    $display("fb_rdata @ (30,30) = %h (expect 39C6ED)", fb_rdata);

    $display("tb_raster_triangle: done");
    $finish;
  end

  initial begin
    #50_000_000;
    $fatal(1, "tb_raster_triangle: timeout");
  end

endmodule: tb_raster_triangle