// raster_scene_top.sv — Phase 2 glue: scene ROM + controller + single-triangle path.
// TB drives frame_start; after frame_done, dump FB the same way as Phase 1.
// How to change: fill triangle_rom + implement scene_controller; then wire do_clear
// into pixel_scanner (see TODO on that port).

module raster_scene_top (
  input  logic                                              clk,
  input  logic                                              rst_n,

  input  logic                                              frame_start,
  output logic                                              frame_busy,
  output logic                                              frame_done,

  input  logic [pkg_raster_params::FB_ADDR_WIDTH-1:0]       fb_raddr,
  output logic [pkg_raster_params::COLOR_WIDTH-1:0]         fb_rdata
);

  import pkg_raster_params::*;

  logic [TRI_IDX_WIDTH-1:0] tri_idx;
  logic signed [COORD_WIDTH-1:0] rom_v0_x, rom_v0_y, rom_v1_x, rom_v1_y, rom_v2_x, rom_v2_y;
  logic [COLOR_WIDTH-1:0] rom_color;

  logic tri_load;
  logic scan_start;
  logic do_clear;
  logic scan_busy;
  logic scan_done;

  triangle_rom u_rom (
    .idx(tri_idx),
    .v0_x(rom_v0_x),
    .v0_y(rom_v0_y),
    .v1_x(rom_v1_x),
    .v1_y(rom_v1_y),
    .v2_x(rom_v2_x),
    .v2_y(rom_v2_y),
    .color(rom_color)
  );

  scene_controller u_ctrl (
    .clk(clk),
    .rst_n(rst_n),
    .frame_start(frame_start),
    .frame_busy(frame_busy),
    .frame_done(frame_done),
    .tri_idx(tri_idx),
    .tri_load(tri_load),
    .scan_start(scan_start),
    .do_clear(do_clear),
    .scan_busy(scan_busy),
    .scan_done(scan_done)
  );

  // Reuse Phase 1 single-triangle datapath.
  // TODO(Om): When pixel_scanner supports do_clear, pass it through raster_top
  //           (or instantiate the datapath here). For now raster_top always clears
  //           on start — you must teach the scanner to skip clear when do_clear=0.
  raster_top u_raster (
    .clk(clk),
    .rst_n(rst_n),
    .start(scan_start),
    .do_clear(do_clear),
    .busy(scan_busy),
    .done(scan_done),
    .tri_load(tri_load),
    .v0_x(rom_v0_x),
    .v0_y(rom_v0_y),
    .v1_x(rom_v1_x),
    .v1_y(rom_v1_y),
    .v2_x(rom_v2_x),
    .v2_y(rom_v2_y),
    .tri_color(rom_color),
    .fb_raddr(fb_raddr),
    .fb_rdata(fb_rdata)
  );

endmodule
