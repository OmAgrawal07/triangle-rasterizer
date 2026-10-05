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
  //   tri0 = large background shape (drawn fi  rst)
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
      0: begin
        v0_x = 10 <<< FRAC_BITS; v0_y = 10 <<< FRAC_BITS;
        v1_x = 42 <<< FRAC_BITS; v1_y = 48 <<< FRAC_BITS;
        v2_x = 54 <<< FRAC_BITS; v2_y = 10 <<< FRAC_BITS;
        color = 24'h39C6ED;
      end
      1: begin
        v0_x = 20 <<< FRAC_BITS; v0_y = 20 <<< FRAC_BITS;
        v1_x = 28 <<< FRAC_BITS; v1_y = 26 <<< FRAC_BITS;
        v2_x = 32 <<< FRAC_BITS; v2_y = 20 <<< FRAC_BITS;
        color = 24'hFF00FF;
      end
      default: begin
        v0_x = '0; v0_y = '0;
        v1_x = '0; v1_y = '0;
        v2_x = '0; v2_y = '0;
        color = 24'hFF0000;
      end
    endcase
  end

endmodule
