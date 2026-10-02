// inside_test.sv — Phase 0 shell only.
// TODO(Om): implement the three-edge inside predicate from the rules sheet.
// Owner: Om. Do not invent a different inequality than the sheet.
// Note: port is named is_inside because "inside" is a SystemVerilog keyword.

module inside_test (
  input  logic signed [2*pkg_raster_params::COORD_WIDTH:0] e0,
  input  logic signed [2*pkg_raster_params::COORD_WIDTH:0] e1,
  input  logic signed [2*pkg_raster_params::COORD_WIDTH:0] e2,
  output logic                                             is_inside
);

  // TODO(Om): is_inside = (e0 ? 0) && (e1 ? 0) && (e2 ? 0) with ? from rules sheet
  //           (typically >= for CCW, including on-edge as inside).
  // TODO(Om): Document any top-left / tie-break rule on the rules sheet first.
  // TODO(Om): always_comb only.
  assign is_inside = 1'b0;

endmodule
