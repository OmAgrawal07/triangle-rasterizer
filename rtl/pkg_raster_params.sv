// Project 2 — shared rasterizer parameters (Phase 0 defaults).
// Update these to match docs/rules-sheet.md once Om fills it in.
package pkg_raster_params;

  // Image size (rules sheet suggests 64×64)
  localparam int WIDTH  = 64;
  localparam int HEIGHT = 64;
  localparam int FB_DEPTH = WIDTH * HEIGHT;

  // Fixed-point: signed Q10.6 (10 integer bits incl. sign contribution + 6 fractional)
  // Total stored width = 16 bits: [15] sign, [14:6] integer, [5:0] fraction.
  localparam int COORD_WIDTH = 16;
  localparam int FRAC_BITS   = 6;
  localparam int INT_BITS    = COORD_WIDTH - FRAC_BITS; // 10

  // RGB888 packing in the framebuffer word
  localparam int COLOR_WIDTH = 24;
  localparam int R_MSB = 23;
  localparam int R_LSB = 16;
  localparam int G_MSB = 15;
  localparam int G_LSB = 8;
  localparam int B_MSB = 7;
  localparam int B_LSB = 0;

  // Address needs enough bits for FB_DEPTH-1
  localparam int FB_ADDR_WIDTH = $clog2(FB_DEPTH);

  // Fixed-point 0.5 in Q-format (pixel center offset)
  localparam logic signed [COORD_WIDTH-1:0] HALF_PIXEL =
      COORD_WIDTH'(1 <<< (FRAC_BITS - 1));

endpackage
