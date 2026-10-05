#ifndef TRIANGLE_H
#define TRIANGLE_H

#include <cstddef>
#include <cstdint>

namespace raster {

// Integer pixel corners; converted to Q10.6 (<< FRAC_BITS) at load time.
// Winding must be CCW in screen space (x right, y down), matching RTL ROM/TBs.
struct Triangle {
  int v0x;
  int v0y;
  int v1x;
  int v1y;
  int v2x;
  int v2y;
  std::uint32_t color;  // RGB888 in low 24 bits (R[23:16] G[15:8] B[7:0])
};

struct Scene {
  const char* name;
  int width;
  int height;
  const Triangle* triangles;
  std::size_t triangle_count;
};

}  // namespace raster

#endif  // TRIANGLE_H
