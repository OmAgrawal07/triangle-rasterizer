// Project 2 — shared rasterizer parameters.
// Phase 3 cartoon robot demo: 128×128, 66 triangles.
package pkg_raster_params;

  localparam int WIDTH  = 128;
  localparam int HEIGHT = 128;
  localparam int FB_DEPTH = WIDTH * HEIGHT;

  // Fixed-point: signed Q10.6
  localparam int COORD_WIDTH = 16;
  localparam int FRAC_BITS   = 6;
  localparam int INT_BITS    = COORD_WIDTH - FRAC_BITS; // 10

  localparam int COLOR_WIDTH = 24;
  localparam int R_MSB = 23;
  localparam int R_LSB = 16;
  localparam int G_MSB = 15;
  localparam int G_LSB = 8;
  localparam int B_MSB = 7;
  localparam int B_LSB = 0;

  localparam int FB_ADDR_WIDTH = $clog2(FB_DEPTH);

  localparam logic signed [COORD_WIDTH-1:0] HALF_PIXEL =
      COORD_WIDTH'(1 <<< (FRAC_BITS - 1));

  localparam int NUM_TRIANGLES = 66;
  localparam int TRI_IDX_WIDTH = $clog2(NUM_TRIANGLES);

endpackage
