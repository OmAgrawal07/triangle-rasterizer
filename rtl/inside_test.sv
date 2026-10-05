// inside_test.sv — Phase 0 shell only.
// Owner: Om. Do not invent a different inequality than the sheet.
// Note: port is named is_inside because "inside" is a SystemVerilog keyword.

module inside_test (
  input  logic signed [2*pkg_raster_params::COORD_WIDTH:0] e0,
  input  logic signed [2*pkg_raster_params::COORD_WIDTH:0] e1,
  input  logic signed [2*pkg_raster_params::COORD_WIDTH:0] e2,
  output logic                                             is_inside
);

  assign is_inside = (e0 >= 0) && (e1 >= 0) && (e2 >= 0);

endmodule
