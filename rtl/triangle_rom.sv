// triangle_rom.sv — Phase 3 cartoon robot scene (128x128).
// Auto-authored low-poly approximation of reference robot.
// Coords are Q10.6 (integer <<< FRAC_BITS), winding matches Phase 1 style.

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

  always_comb begin
    v0_x = '0; v0_y = '0;
    v1_x = '0; v1_y = '0;
    v2_x = '0; v2_y = '0;
    color = 24'hFF0000;

    unique case (idx)
      // head outline
      0: begin
        v0_x = 38 <<< FRAC_BITS; v0_y = 12 <<< FRAC_BITS;
        v1_x = 38 <<< FRAC_BITS; v1_y = 52 <<< FRAC_BITS;
        v2_x = 90 <<< FRAC_BITS; v2_y = 12 <<< FRAC_BITS;
        color = 24'h1A5276;
      end
      1: begin
        v0_x = 90 <<< FRAC_BITS; v0_y = 12 <<< FRAC_BITS;
        v1_x = 38 <<< FRAC_BITS; v1_y = 52 <<< FRAC_BITS;
        v2_x = 90 <<< FRAC_BITS; v2_y = 52 <<< FRAC_BITS;
        color = 24'h1A5276;
      end
      // head fill
      2: begin
        v0_x = 42 <<< FRAC_BITS; v0_y = 16 <<< FRAC_BITS;
        v1_x = 42 <<< FRAC_BITS; v1_y = 48 <<< FRAC_BITS;
        v2_x = 86 <<< FRAC_BITS; v2_y = 16 <<< FRAC_BITS;
        color = 24'h5DADE2;
      end
      3: begin
        v0_x = 86 <<< FRAC_BITS; v0_y = 16 <<< FRAC_BITS;
        v1_x = 42 <<< FRAC_BITS; v1_y = 48 <<< FRAC_BITS;
        v2_x = 86 <<< FRAC_BITS; v2_y = 48 <<< FRAC_BITS;
        color = 24'h5DADE2;
      end
      // antenna base
      4: begin
        v0_x = 48 <<< FRAC_BITS; v0_y = 4 <<< FRAC_BITS;
        v1_x = 48 <<< FRAC_BITS; v1_y = 12 <<< FRAC_BITS;
        v2_x = 80 <<< FRAC_BITS; v2_y = 4 <<< FRAC_BITS;
        color = 24'h5D6D7E;
      end
      5: begin
        v0_x = 80 <<< FRAC_BITS; v0_y = 4 <<< FRAC_BITS;
        v1_x = 48 <<< FRAC_BITS; v1_y = 12 <<< FRAC_BITS;
        v2_x = 80 <<< FRAC_BITS; v2_y = 12 <<< FRAC_BITS;
        color = 24'h5D6D7E;
      end
      // stripe pink
      6: begin
        v0_x = 50 <<< FRAC_BITS; v0_y = 5 <<< FRAC_BITS;
        v1_x = 50 <<< FRAC_BITS; v1_y = 11 <<< FRAC_BITS;
        v2_x = 56 <<< FRAC_BITS; v2_y = 5 <<< FRAC_BITS;
        color = 24'hFF69B4;
      end
      7: begin
        v0_x = 56 <<< FRAC_BITS; v0_y = 5 <<< FRAC_BITS;
        v1_x = 50 <<< FRAC_BITS; v1_y = 11 <<< FRAC_BITS;
        v2_x = 56 <<< FRAC_BITS; v2_y = 11 <<< FRAC_BITS;
        color = 24'hFF69B4;
      end
      // stripe yellow
      8: begin
        v0_x = 58 <<< FRAC_BITS; v0_y = 5 <<< FRAC_BITS;
        v1_x = 58 <<< FRAC_BITS; v1_y = 11 <<< FRAC_BITS;
        v2_x = 64 <<< FRAC_BITS; v2_y = 5 <<< FRAC_BITS;
        color = 24'hF4D03F;
      end
      9: begin
        v0_x = 64 <<< FRAC_BITS; v0_y = 5 <<< FRAC_BITS;
        v1_x = 58 <<< FRAC_BITS; v1_y = 11 <<< FRAC_BITS;
        v2_x = 64 <<< FRAC_BITS; v2_y = 11 <<< FRAC_BITS;
        color = 24'hF4D03F;
      end
      // stripe pink2
      10: begin
        v0_x = 66 <<< FRAC_BITS; v0_y = 5 <<< FRAC_BITS;
        v1_x = 66 <<< FRAC_BITS; v1_y = 11 <<< FRAC_BITS;
        v2_x = 72 <<< FRAC_BITS; v2_y = 5 <<< FRAC_BITS;
        color = 24'hFF69B4;
      end
      11: begin
        v0_x = 72 <<< FRAC_BITS; v0_y = 5 <<< FRAC_BITS;
        v1_x = 66 <<< FRAC_BITS; v1_y = 11 <<< FRAC_BITS;
        v2_x = 72 <<< FRAC_BITS; v2_y = 11 <<< FRAC_BITS;
        color = 24'hFF69B4;
      end
      // stripe yellow2
      12: begin
        v0_x = 74 <<< FRAC_BITS; v0_y = 5 <<< FRAC_BITS;
        v1_x = 74 <<< FRAC_BITS; v1_y = 11 <<< FRAC_BITS;
        v2_x = 80 <<< FRAC_BITS; v2_y = 5 <<< FRAC_BITS;
        color = 24'hF4D03F;
      end
      13: begin
        v0_x = 80 <<< FRAC_BITS; v0_y = 5 <<< FRAC_BITS;
        v1_x = 74 <<< FRAC_BITS; v1_y = 11 <<< FRAC_BITS;
        v2_x = 80 <<< FRAC_BITS; v2_y = 11 <<< FRAC_BITS;
        color = 24'hF4D03F;
      end
      // left ear
      14: begin
        v0_x = 22 <<< FRAC_BITS; v0_y = 24 <<< FRAC_BITS;
        v1_x = 22 <<< FRAC_BITS; v1_y = 44 <<< FRAC_BITS;
        v2_x = 42 <<< FRAC_BITS; v2_y = 24 <<< FRAC_BITS;
        color = 24'hF4D03F;
      end
      15: begin
        v0_x = 42 <<< FRAC_BITS; v0_y = 24 <<< FRAC_BITS;
        v1_x = 22 <<< FRAC_BITS; v1_y = 44 <<< FRAC_BITS;
        v2_x = 42 <<< FRAC_BITS; v2_y = 44 <<< FRAC_BITS;
        color = 24'hF4D03F;
      end
      // right ear
      16: begin
        v0_x = 86 <<< FRAC_BITS; v0_y = 24 <<< FRAC_BITS;
        v1_x = 86 <<< FRAC_BITS; v1_y = 44 <<< FRAC_BITS;
        v2_x = 106 <<< FRAC_BITS; v2_y = 24 <<< FRAC_BITS;
        color = 24'hF4D03F;
      end
      17: begin
        v0_x = 106 <<< FRAC_BITS; v0_y = 24 <<< FRAC_BITS;
        v1_x = 86 <<< FRAC_BITS; v1_y = 44 <<< FRAC_BITS;
        v2_x = 106 <<< FRAC_BITS; v2_y = 44 <<< FRAC_BITS;
        color = 24'hF4D03F;
      end
      // left eye
      18: begin
        v0_x = 50 <<< FRAC_BITS; v0_y = 26 <<< FRAC_BITS;
        v1_x = 50 <<< FRAC_BITS; v1_y = 40 <<< FRAC_BITS;
        v2_x = 58 <<< FRAC_BITS; v2_y = 26 <<< FRAC_BITS;
        color = 24'h1C2833;
      end
      19: begin
        v0_x = 58 <<< FRAC_BITS; v0_y = 26 <<< FRAC_BITS;
        v1_x = 50 <<< FRAC_BITS; v1_y = 40 <<< FRAC_BITS;
        v2_x = 58 <<< FRAC_BITS; v2_y = 40 <<< FRAC_BITS;
        color = 24'h1C2833;
      end
      // right eye
      20: begin
        v0_x = 70 <<< FRAC_BITS; v0_y = 26 <<< FRAC_BITS;
        v1_x = 70 <<< FRAC_BITS; v1_y = 40 <<< FRAC_BITS;
        v2_x = 78 <<< FRAC_BITS; v2_y = 26 <<< FRAC_BITS;
        color = 24'h1C2833;
      end
      21: begin
        v0_x = 78 <<< FRAC_BITS; v0_y = 26 <<< FRAC_BITS;
        v1_x = 70 <<< FRAC_BITS; v1_y = 40 <<< FRAC_BITS;
        v2_x = 78 <<< FRAC_BITS; v2_y = 40 <<< FRAC_BITS;
        color = 24'h1C2833;
      end
      // left eye shine
      22: begin
        v0_x = 52 <<< FRAC_BITS; v0_y = 28 <<< FRAC_BITS;
        v1_x = 52 <<< FRAC_BITS; v1_y = 34 <<< FRAC_BITS;
        v2_x = 56 <<< FRAC_BITS; v2_y = 28 <<< FRAC_BITS;
        color = 24'hFDFEFE;
      end
      // right eye shine
      23: begin
        v0_x = 72 <<< FRAC_BITS; v0_y = 28 <<< FRAC_BITS;
        v1_x = 72 <<< FRAC_BITS; v1_y = 34 <<< FRAC_BITS;
        v2_x = 76 <<< FRAC_BITS; v2_y = 28 <<< FRAC_BITS;
        color = 24'hFDFEFE;
      end
      // mouth
      24: begin
        v0_x = 54 <<< FRAC_BITS; v0_y = 42 <<< FRAC_BITS;
        v1_x = 54 <<< FRAC_BITS; v1_y = 46 <<< FRAC_BITS;
        v2_x = 74 <<< FRAC_BITS; v2_y = 42 <<< FRAC_BITS;
        color = 24'h1C2833;
      end
      25: begin
        v0_x = 74 <<< FRAC_BITS; v0_y = 42 <<< FRAC_BITS;
        v1_x = 54 <<< FRAC_BITS; v1_y = 46 <<< FRAC_BITS;
        v2_x = 74 <<< FRAC_BITS; v2_y = 46 <<< FRAC_BITS;
        color = 24'h1C2833;
      end
      // neck
      26: begin
        v0_x = 56 <<< FRAC_BITS; v0_y = 48 <<< FRAC_BITS;
        v1_x = 56 <<< FRAC_BITS; v1_y = 58 <<< FRAC_BITS;
        v2_x = 72 <<< FRAC_BITS; v2_y = 48 <<< FRAC_BITS;
        color = 24'h95A5A6;
      end
      27: begin
        v0_x = 72 <<< FRAC_BITS; v0_y = 48 <<< FRAC_BITS;
        v1_x = 56 <<< FRAC_BITS; v1_y = 58 <<< FRAC_BITS;
        v2_x = 72 <<< FRAC_BITS; v2_y = 58 <<< FRAC_BITS;
        color = 24'h95A5A6;
      end
      // torso outline
      28: begin
        v0_x = 42 <<< FRAC_BITS; v0_y = 56 <<< FRAC_BITS;
        v1_x = 42 <<< FRAC_BITS; v1_y = 96 <<< FRAC_BITS;
        v2_x = 86 <<< FRAC_BITS; v2_y = 56 <<< FRAC_BITS;
        color = 24'h1A5276;
      end
      29: begin
        v0_x = 86 <<< FRAC_BITS; v0_y = 56 <<< FRAC_BITS;
        v1_x = 42 <<< FRAC_BITS; v1_y = 96 <<< FRAC_BITS;
        v2_x = 86 <<< FRAC_BITS; v2_y = 96 <<< FRAC_BITS;
        color = 24'h1A5276;
      end
      // torso fill
      30: begin
        v0_x = 46 <<< FRAC_BITS; v0_y = 60 <<< FRAC_BITS;
        v1_x = 46 <<< FRAC_BITS; v1_y = 92 <<< FRAC_BITS;
        v2_x = 82 <<< FRAC_BITS; v2_y = 60 <<< FRAC_BITS;
        color = 24'h5DADE2;
      end
      31: begin
        v0_x = 82 <<< FRAC_BITS; v0_y = 60 <<< FRAC_BITS;
        v1_x = 46 <<< FRAC_BITS; v1_y = 92 <<< FRAC_BITS;
        v2_x = 82 <<< FRAC_BITS; v2_y = 92 <<< FRAC_BITS;
        color = 24'h5DADE2;
      end
      // button pink
      32: begin
        v0_x = 52 <<< FRAC_BITS; v0_y = 72 <<< FRAC_BITS;
        v1_x = 52 <<< FRAC_BITS; v1_y = 80 <<< FRAC_BITS;
        v2_x = 60 <<< FRAC_BITS; v2_y = 72 <<< FRAC_BITS;
        color = 24'hFF69B4;
      end
      33: begin
        v0_x = 60 <<< FRAC_BITS; v0_y = 72 <<< FRAC_BITS;
        v1_x = 52 <<< FRAC_BITS; v1_y = 80 <<< FRAC_BITS;
        v2_x = 60 <<< FRAC_BITS; v2_y = 80 <<< FRAC_BITS;
        color = 24'hFF69B4;
      end
      // button yellow
      34: begin
        v0_x = 62 <<< FRAC_BITS; v0_y = 72 <<< FRAC_BITS;
        v1_x = 62 <<< FRAC_BITS; v1_y = 80 <<< FRAC_BITS;
        v2_x = 70 <<< FRAC_BITS; v2_y = 72 <<< FRAC_BITS;
        color = 24'hF4D03F;
      end
      35: begin
        v0_x = 70 <<< FRAC_BITS; v0_y = 72 <<< FRAC_BITS;
        v1_x = 62 <<< FRAC_BITS; v1_y = 80 <<< FRAC_BITS;
        v2_x = 70 <<< FRAC_BITS; v2_y = 80 <<< FRAC_BITS;
        color = 24'hF4D03F;
      end
      // button purple
      36: begin
        v0_x = 72 <<< FRAC_BITS; v0_y = 72 <<< FRAC_BITS;
        v1_x = 72 <<< FRAC_BITS; v1_y = 80 <<< FRAC_BITS;
        v2_x = 80 <<< FRAC_BITS; v2_y = 72 <<< FRAC_BITS;
        color = 24'h9B59B6;
      end
      37: begin
        v0_x = 80 <<< FRAC_BITS; v0_y = 72 <<< FRAC_BITS;
        v1_x = 72 <<< FRAC_BITS; v1_y = 80 <<< FRAC_BITS;
        v2_x = 80 <<< FRAC_BITS; v2_y = 80 <<< FRAC_BITS;
        color = 24'h9B59B6;
      end
      // left shoulder
      38: begin
        v0_x = 30 <<< FRAC_BITS; v0_y = 64 <<< FRAC_BITS;
        v1_x = 30 <<< FRAC_BITS; v1_y = 76 <<< FRAC_BITS;
        v2_x = 46 <<< FRAC_BITS; v2_y = 64 <<< FRAC_BITS;
        color = 24'h95A5A6;
      end
      39: begin
        v0_x = 46 <<< FRAC_BITS; v0_y = 64 <<< FRAC_BITS;
        v1_x = 30 <<< FRAC_BITS; v1_y = 76 <<< FRAC_BITS;
        v2_x = 46 <<< FRAC_BITS; v2_y = 76 <<< FRAC_BITS;
        color = 24'h95A5A6;
      end
      // right shoulder
      40: begin
        v0_x = 82 <<< FRAC_BITS; v0_y = 64 <<< FRAC_BITS;
        v1_x = 82 <<< FRAC_BITS; v1_y = 76 <<< FRAC_BITS;
        v2_x = 98 <<< FRAC_BITS; v2_y = 64 <<< FRAC_BITS;
        color = 24'h95A5A6;
      end
      41: begin
        v0_x = 98 <<< FRAC_BITS; v0_y = 64 <<< FRAC_BITS;
        v1_x = 82 <<< FRAC_BITS; v1_y = 76 <<< FRAC_BITS;
        v2_x = 98 <<< FRAC_BITS; v2_y = 76 <<< FRAC_BITS;
        color = 24'h95A5A6;
      end
      // left arm
      42: begin
        v0_x = 28 <<< FRAC_BITS; v0_y = 76 <<< FRAC_BITS;
        v1_x = 28 <<< FRAC_BITS; v1_y = 104 <<< FRAC_BITS;
        v2_x = 44 <<< FRAC_BITS; v2_y = 76 <<< FRAC_BITS;
        color = 24'h5DADE2;
      end
      43: begin
        v0_x = 44 <<< FRAC_BITS; v0_y = 76 <<< FRAC_BITS;
        v1_x = 28 <<< FRAC_BITS; v1_y = 104 <<< FRAC_BITS;
        v2_x = 44 <<< FRAC_BITS; v2_y = 104 <<< FRAC_BITS;
        color = 24'h5DADE2;
      end
      // right arm
      44: begin
        v0_x = 84 <<< FRAC_BITS; v0_y = 76 <<< FRAC_BITS;
        v1_x = 84 <<< FRAC_BITS; v1_y = 104 <<< FRAC_BITS;
        v2_x = 100 <<< FRAC_BITS; v2_y = 76 <<< FRAC_BITS;
        color = 24'h5DADE2;
      end
      45: begin
        v0_x = 100 <<< FRAC_BITS; v0_y = 76 <<< FRAC_BITS;
        v1_x = 84 <<< FRAC_BITS; v1_y = 104 <<< FRAC_BITS;
        v2_x = 100 <<< FRAC_BITS; v2_y = 104 <<< FRAC_BITS;
        color = 24'h5DADE2;
      end
      // left wrist
      46: begin
        v0_x = 28 <<< FRAC_BITS; v0_y = 104 <<< FRAC_BITS;
        v1_x = 28 <<< FRAC_BITS; v1_y = 110 <<< FRAC_BITS;
        v2_x = 44 <<< FRAC_BITS; v2_y = 104 <<< FRAC_BITS;
        color = 24'h5D6D7E;
      end
      47: begin
        v0_x = 44 <<< FRAC_BITS; v0_y = 104 <<< FRAC_BITS;
        v1_x = 28 <<< FRAC_BITS; v1_y = 110 <<< FRAC_BITS;
        v2_x = 44 <<< FRAC_BITS; v2_y = 110 <<< FRAC_BITS;
        color = 24'h5D6D7E;
      end
      // right wrist
      48: begin
        v0_x = 84 <<< FRAC_BITS; v0_y = 104 <<< FRAC_BITS;
        v1_x = 84 <<< FRAC_BITS; v1_y = 110 <<< FRAC_BITS;
        v2_x = 100 <<< FRAC_BITS; v2_y = 104 <<< FRAC_BITS;
        color = 24'h5D6D7E;
      end
      49: begin
        v0_x = 100 <<< FRAC_BITS; v0_y = 104 <<< FRAC_BITS;
        v1_x = 84 <<< FRAC_BITS; v1_y = 110 <<< FRAC_BITS;
        v2_x = 100 <<< FRAC_BITS; v2_y = 110 <<< FRAC_BITS;
        color = 24'h5D6D7E;
      end
      // left hand
      50: begin
        v0_x = 24 <<< FRAC_BITS; v0_y = 110 <<< FRAC_BITS;
        v1_x = 24 <<< FRAC_BITS; v1_y = 122 <<< FRAC_BITS;
        v2_x = 48 <<< FRAC_BITS; v2_y = 110 <<< FRAC_BITS;
        color = 24'h95A5A6;
      end
      51: begin
        v0_x = 48 <<< FRAC_BITS; v0_y = 110 <<< FRAC_BITS;
        v1_x = 24 <<< FRAC_BITS; v1_y = 122 <<< FRAC_BITS;
        v2_x = 48 <<< FRAC_BITS; v2_y = 122 <<< FRAC_BITS;
        color = 24'h95A5A6;
      end
      // right hand
      52: begin
        v0_x = 80 <<< FRAC_BITS; v0_y = 110 <<< FRAC_BITS;
        v1_x = 80 <<< FRAC_BITS; v1_y = 122 <<< FRAC_BITS;
        v2_x = 104 <<< FRAC_BITS; v2_y = 110 <<< FRAC_BITS;
        color = 24'h95A5A6;
      end
      53: begin
        v0_x = 104 <<< FRAC_BITS; v0_y = 110 <<< FRAC_BITS;
        v1_x = 80 <<< FRAC_BITS; v1_y = 122 <<< FRAC_BITS;
        v2_x = 104 <<< FRAC_BITS; v2_y = 122 <<< FRAC_BITS;
        color = 24'h95A5A6;
      end
      // left hip
      54: begin
        v0_x = 50 <<< FRAC_BITS; v0_y = 92 <<< FRAC_BITS;
        v1_x = 50 <<< FRAC_BITS; v1_y = 102 <<< FRAC_BITS;
        v2_x = 60 <<< FRAC_BITS; v2_y = 92 <<< FRAC_BITS;
        color = 24'h95A5A6;
      end
      55: begin
        v0_x = 60 <<< FRAC_BITS; v0_y = 92 <<< FRAC_BITS;
        v1_x = 50 <<< FRAC_BITS; v1_y = 102 <<< FRAC_BITS;
        v2_x = 60 <<< FRAC_BITS; v2_y = 102 <<< FRAC_BITS;
        color = 24'h95A5A6;
      end
      // right hip
      56: begin
        v0_x = 68 <<< FRAC_BITS; v0_y = 92 <<< FRAC_BITS;
        v1_x = 68 <<< FRAC_BITS; v1_y = 102 <<< FRAC_BITS;
        v2_x = 78 <<< FRAC_BITS; v2_y = 92 <<< FRAC_BITS;
        color = 24'h95A5A6;
      end
      57: begin
        v0_x = 78 <<< FRAC_BITS; v0_y = 92 <<< FRAC_BITS;
        v1_x = 68 <<< FRAC_BITS; v1_y = 102 <<< FRAC_BITS;
        v2_x = 78 <<< FRAC_BITS; v2_y = 102 <<< FRAC_BITS;
        color = 24'h95A5A6;
      end
      // left leg
      58: begin
        v0_x = 48 <<< FRAC_BITS; v0_y = 102 <<< FRAC_BITS;
        v1_x = 48 <<< FRAC_BITS; v1_y = 116 <<< FRAC_BITS;
        v2_x = 62 <<< FRAC_BITS; v2_y = 102 <<< FRAC_BITS;
        color = 24'h5DADE2;
      end
      59: begin
        v0_x = 62 <<< FRAC_BITS; v0_y = 102 <<< FRAC_BITS;
        v1_x = 48 <<< FRAC_BITS; v1_y = 116 <<< FRAC_BITS;
        v2_x = 62 <<< FRAC_BITS; v2_y = 116 <<< FRAC_BITS;
        color = 24'h5DADE2;
      end
      // right leg
      60: begin
        v0_x = 66 <<< FRAC_BITS; v0_y = 102 <<< FRAC_BITS;
        v1_x = 66 <<< FRAC_BITS; v1_y = 116 <<< FRAC_BITS;
        v2_x = 80 <<< FRAC_BITS; v2_y = 102 <<< FRAC_BITS;
        color = 24'h5DADE2;
      end
      61: begin
        v0_x = 80 <<< FRAC_BITS; v0_y = 102 <<< FRAC_BITS;
        v1_x = 66 <<< FRAC_BITS; v1_y = 116 <<< FRAC_BITS;
        v2_x = 80 <<< FRAC_BITS; v2_y = 116 <<< FRAC_BITS;
        color = 24'h5DADE2;
      end
      // left foot
      62: begin
        v0_x = 42 <<< FRAC_BITS; v0_y = 116 <<< FRAC_BITS;
        v1_x = 42 <<< FRAC_BITS; v1_y = 126 <<< FRAC_BITS;
        v2_x = 64 <<< FRAC_BITS; v2_y = 116 <<< FRAC_BITS;
        color = 24'hF4D03F;
      end
      63: begin
        v0_x = 64 <<< FRAC_BITS; v0_y = 116 <<< FRAC_BITS;
        v1_x = 42 <<< FRAC_BITS; v1_y = 126 <<< FRAC_BITS;
        v2_x = 64 <<< FRAC_BITS; v2_y = 126 <<< FRAC_BITS;
        color = 24'hF4D03F;
      end
      // right foot
      64: begin
        v0_x = 64 <<< FRAC_BITS; v0_y = 116 <<< FRAC_BITS;
        v1_x = 64 <<< FRAC_BITS; v1_y = 126 <<< FRAC_BITS;
        v2_x = 86 <<< FRAC_BITS; v2_y = 116 <<< FRAC_BITS;
        color = 24'hF4D03F;
      end
      65: begin
        v0_x = 86 <<< FRAC_BITS; v0_y = 116 <<< FRAC_BITS;
        v1_x = 64 <<< FRAC_BITS; v1_y = 126 <<< FRAC_BITS;
        v2_x = 86 <<< FRAC_BITS; v2_y = 126 <<< FRAC_BITS;
        color = 24'hF4D03F;
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
