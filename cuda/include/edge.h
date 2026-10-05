// Bit-exact edge / inside predicates matching RTL edge_function + inside_test.
// Same formula as docs/rules-sheet.md:
//   E_AB(P) = (Px - Ax)*(By - Ay) - (Py - Ay)*(Bx - Ax)
//   inside = E0 >= 0 && E1 >= 0 && E2 >= 0

#ifndef EDGE_H
#define EDGE_H

#include <cstdint>

#ifdef __CUDACC__
#define RASTER_HD __host__ __device__
#else
#define RASTER_HD
#endif

namespace raster {

RASTER_HD inline std::int64_t edge_ab(std::int32_t ax, std::int32_t ay,
                                      std::int32_t bx, std::int32_t by,
                                      std::int32_t px, std::int32_t py) {
  const std::int64_t t1 = static_cast<std::int64_t>(px) - ax;
  const std::int64_t t2 = static_cast<std::int64_t>(by) - ay;
  const std::int64_t t3 = static_cast<std::int64_t>(py) - ay;
  const std::int64_t t4 = static_cast<std::int64_t>(bx) - ax;
  return t1 * t2 - t3 * t4;
}

RASTER_HD inline bool is_inside(std::int32_t v0x, std::int32_t v0y,
                                std::int32_t v1x, std::int32_t v1y,
                                std::int32_t v2x, std::int32_t v2y,
                                std::int32_t px, std::int32_t py) {
  const std::int64_t e0 = edge_ab(v0x, v0y, v1x, v1y, px, py);
  const std::int64_t e1 = edge_ab(v1x, v1y, v2x, v2y, px, py);
  const std::int64_t e2 = edge_ab(v2x, v2y, v0x, v0y, px, py);
  return (e0 >= 0) && (e1 >= 0) && (e2 >= 0);
}

}  // namespace raster

#endif  // EDGE_H
