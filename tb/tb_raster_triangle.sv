`timescale 1ns/1ps

module tb_raster_triangle;
  import pkg_raster_params::*;

  logic clk, rst_n, start, busy, done;

  logic                          tri_load;
  logic                          do_clear;
  logic signed [COORD_WIDTH-1:0] v0_x, v0_y, v1_x, v1_y, v2_x, v2_y;
  logic        [COLOR_WIDTH-1:0] tri_color;
  logic [FB_ADDR_WIDTH-1:0]      fb_raddr;
  logic [COLOR_WIDTH-1:0]        fb_rdata;

  integer dump_fd;
  integer pix_i;

  raster_top dut (.*);

  initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
  end

  initial begin
    rst_n     = 1'b0;
    start     = 1'b0;
    tri_load  = 1'b0;
    do_clear  = 1'b1;  // Phase 1: always clear then scan
    fb_raddr  = '0;

    repeat (4) @(posedge clk);
    rst_n = 1'b1;
    repeat (2) @(posedge clk);

    // CCW triangle in Q10.6 (integer pixel << FRAC_BITS)
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

    // Dump full framebuffer as raw RGB888 (R,G,B bytes), addr order 0 .. FB_DEPTH-1
    dump_fd = $fopen("sim/out/frame.rgb", "wb");
    if (dump_fd == 0)
      $fatal(1, "tb_raster_triangle: could not open sim/out/frame.rgb");

    for (pix_i = 0; pix_i < FB_DEPTH; pix_i++) begin
      fb_raddr = FB_ADDR_WIDTH'(pix_i);
      @(posedge clk);
      @(posedge clk);
      $fwrite(dump_fd, "%c", fb_rdata[23:16]);
      $fwrite(dump_fd, "%c", fb_rdata[15:8]);
      $fwrite(dump_fd, "%c", fb_rdata[7:0]);
    end
    $fclose(dump_fd);
    $display("tb_raster_triangle: wrote sim/out/frame.rgb (%0d pixels)", FB_DEPTH);

    $display("tb_raster_triangle: done");
    $finish;
  end

  initial begin
    #50_000_000;
    $fatal(1, "tb_raster_triangle: timeout");
  end

endmodule : tb_raster_triangle
