// triangle_rom.sv — Phase 2 scene data (Om owns the triangles).
// Combinational ROM: index in → one triangle's verts + color out.
// Coords must be Q10.6 (integer << FRAC_BITS), CCW, per rules sheet.

module triangle_rom (
  input  logic [pkg_raster_params::TRI_IDX_WIDTH-1:0]      idx,

  output logic signed [pkg_raster_params::COORD_WIDTH-1:0] v0_x,
  output logic signed [pkg_raster_params::COORD_WIDTH-1:0] v0_y,
  output logic signed [pkg_raster_params::COORD_WIDTH-1:0] v1_x,
  output logic signed [pkg_raster_params::COORD_WIDTH-1:0] v1_y,
  output logic signed [pkg_raster_params::COORD_WIDTH-1:0] v2_x,
  output logic signed [pkg_raster_params::COORD_WIDTH-1:0] v2_y,
  output logic        [pkg_raster_params::COLOR_WIDTH-1:0] color
);

  import pkg_raster_params::*;

  // TODO(Om): Fill NUM_TRIANGLES entries. Suggested Phase 2 starter:
  //   tri0 = large background shape (drawn first)
  //   tri1 = smaller overlapping shape (drawn second → wins in overlap)
  // TODO(Om): All verts CCW; use (pixel <<< FRAC_BITS) — no HALF_PIXEL on corners.
  // TODO(Om): always_comb case(idx) or parallel arrays — combo only, no clock.

  always_comb begin
    // Stub defaults so the design elaborates; replace with your scene.
    v0_x = '0; v0_y = '0;
    v1_x = '0; v1_y = '0;
    v2_x = '0; v2_y = '0;
    color = 24'hFF0000;

    unique case (idx)
      // TODO(Om): idx 0: {v0,v1,v2,color} = ...
      // TODO(Om): idx 1: {v0,v1,v2,color} = ...
      default: ;
    endcase
  end

endmodule
