// edge_function.sv — Phase 0 shell only.
// TODO(Om): implement signed edge function; do not leave this as a stub forever.
//
// Spec reminder (lock exact formula in docs/rules-sheet.md):
//   For directed edge A→B and sample P, E is proportional to (B-A)×(P-A).
// Owner: Om (learning core). Assistant must not fill the math in.

module edge_function (
  input  logic signed [pkg_raster_params::COORD_WIDTH-1:0]   ax,
  input  logic signed [pkg_raster_params::COORD_WIDTH-1:0]   ay,
  input  logic signed [pkg_raster_params::COORD_WIDTH-1:0]   bx,
  input  logic signed [pkg_raster_params::COORD_WIDTH-1:0]   by,
  input  logic signed [pkg_raster_params::COORD_WIDTH-1:0]   px,
  input  logic signed [pkg_raster_params::COORD_WIDTH-1:0]   py,
  // Wider result for multiply growth — adjust when you lock Q-format.
  output logic signed [2*pkg_raster_params::COORD_WIDTH:0]   e
);

  // TODO(Om): Compute E_AB(P) from the rules sheet (fixed-point, correct bit growth).
  // TODO(Om): Prefer always_comb; no sequential state in this module.
  // TODO(Om): Unit-test known inside/outside/on-edge points before wiring the FSM.
  assign e = '0;

endmodule
