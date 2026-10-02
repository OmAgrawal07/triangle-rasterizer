// triangle_regs.sv — Phase 0 shell only.
// TODO(Om): hold V0,V1,V2 + color for the current triangle.
// Owner: Om.

module triangle_regs (
  input  logic                                           clk,
  input  logic                                           rst_n,

  input  logic                                           load,
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

  // TODO(Om): always_ff registers — on rst_n low clear; on load capture inputs.
  // TODO(Om): Decide whether vertices are integer pixels or already Q-format;
  //           match docs/rules-sheet.md before Phase 1.
  // TODO(Om): Hold values stable for the entire pixel scan (load only when !busy).

  assign v0_x  = '0;
  assign v0_y  = '0;
  assign v1_x  = '0;
  assign v1_y  = '0;
  assign v2_x  = '0;
  assign v2_y  = '0;
  assign color = '0;

  logic unused;
  assign unused = clk ^ rst_n ^ load ^ color_i[0] ^
                  v0_x_i[0] ^ v0_y_i[0] ^ v1_x_i[0] ^ v1_y_i[0] ^
                  v2_x_i[0] ^ v2_y_i[0];

endmodule
