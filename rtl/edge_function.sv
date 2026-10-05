// edge_function.sv — Phase 0 shell only.
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

  // pkg_raster_params::COORD_WIDTH-1:0 tells us to go to the sv file, look at coord width
  // and subtract 1 from it and go to 0
  // Currently is equal to [15:0] because COORD_WIDTH is 16
  logic signed [pkg_raster_params::COORD_WIDTH-1:0] t1, t2, t3, t4;
  logic signed [2*pkg_raster_params::COORD_WIDTH:0] p1, p2;

  always_comb begin
    t1 = px - ax;
    t2 = by - ay;
    t3 = py - ay;
    t4 = bx - ax;
    p1 = t1 * t2;
    p2 = t3 * t4;
    e = p1 - p2;
  end

endmodule
