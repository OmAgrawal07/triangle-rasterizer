`timescale 1ns/1ps

// tb_raster_scene.sv — Phase 2 multi-triangle frame (Om fills stimulus once ROM/controller work).
// Elaborate-only until scene_controller is implemented (frame_done never fires from stub).

module tb_raster_scene;
  import pkg_raster_params::*;

  logic clk, rst_n;
  logic frame_start, frame_busy, frame_done;
  logic [FB_ADDR_WIDTH-1:0] fb_raddr;
  logic [COLOR_WIDTH-1:0]   fb_rdata;

  integer dump_fd;
  integer pix_i;

  raster_scene_top dut (
    .clk(clk),
    .rst_n(rst_n),
    .frame_start(frame_start),
    .frame_busy(frame_busy),
    .frame_done(frame_done),
    .fb_raddr(fb_raddr),
    .fb_rdata(fb_rdata)
  );

  initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
  end

  initial begin
    rst_n       = 1'b0;
    frame_start = 1'b0;
    fb_raddr    = '0;

    repeat (4) @(posedge clk);
    rst_n = 1'b1;
    repeat (2) @(posedge clk);

    // TODO(Om): After scene_controller works:
    //   pulse frame_start;
    //   wait (frame_done);
    //   dump FB to sim/out/scene.rgb (same loop as tb_raster_triangle);
    //   then: python3 scripts/dump_to_png.py sim/out/scene.rgb sim/out/scene.png
    // TODO(Om): Overlap check — pick an addr in the overlap region; change ROM order;
    //           confirm winning color changes (painter's algorithm).

    @(posedge clk);
    frame_start = 1'b1;
    @(posedge clk);
    frame_start = 1'b0;

    // Stub controller never asserts frame_done — Phase 2 elaborate smoke only.
    repeat (20) @(posedge clk);
    $display("tb_raster_scene: ELAB_OK (implement controller/ROM, then wait frame_done + dump)");
    $finish;
  end

  initial begin
    #200_000_000;
    $fatal(1, "tb_raster_scene: timeout");
  end

endmodule
