// triangle_regs.sv — Phase 0 shell only.
// Owner: Om.

module triangle_regs (
  input  logic                                           clk,
  input  logic                                           rst_n,

  input  logic                                           load,
  // All inputs are fixed-point Q10.6 (signed 16-bit) coordinates, except color.
  // aka they are all [15:0] signed, with 6 fractional bits.
  input  logic signed [pkg_raster_params::COORD_WIDTH-1:0] v0_x_i,
  input  logic signed [pkg_raster_params::COORD_WIDTH-1:0] v0_y_i,
  input  logic signed [pkg_raster_params::COORD_WIDTH-1:0] v1_x_i,
  input  logic signed [pkg_raster_params::COORD_WIDTH-1:0] v1_y_i,
  input  logic signed [pkg_raster_params::COORD_WIDTH-1:0] v2_x_i,
  input  logic signed [pkg_raster_params::COORD_WIDTH-1:0] v2_y_i,
  input  logic        [pkg_raster_params::COLOR_WIDTH-1:0] color_i,

  output logic signed [pkg_raster_params::COORD_WIDTH-1:0] v0_x,
  output logic signed [pkg_raster_params::COORD_WIDTH-1:0] v0_y,
  output logic signed [pkg_raster_params::COORD_WIDTH-1:0] v1_x,
  output logic signed [pkg_raster_params::COORD_WIDTH-1:0] v1_y,
  output logic signed [pkg_raster_params::COORD_WIDTH-1:0] v2_x,
  output logic signed [pkg_raster_params::COORD_WIDTH-1:0] v2_y,
  output logic        [pkg_raster_params::COLOR_WIDTH-1:0] color
);

  always_ff @(posedge clk, negedge rst_n)
    if (~rst_n)
      {v0_x, v0_y, v1_x, v1_y, v2_x, v2_y, color} <= '0;
    else if (load)
      {v0_x, v0_y, v1_x, v1_y, v2_x, v2_y, color} <=
          {v0_x_i, v0_y_i, v1_x_i, v1_y_i, v2_x_i, v2_y_i, color_i};

endmodule
