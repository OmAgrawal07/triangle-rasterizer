#include "rasterize.h"

#include <stdexcept>

#include "edge.h"
#include "raster_params.h"

namespace raster {

void rasterize_cpu(const Scene& scene, std::vector<std::uint32_t>& framebuffer) {
  if (scene.width <= 0 || scene.height <= 0) {
    throw std::runtime_error("rasterize_cpu: invalid scene dimensions");
  }
  if (scene.triangles == nullptr && scene.triangle_count > 0) {
    throw std::runtime_error("rasterize_cpu: null triangle list");
  }

  const std::size_t pixel_count =
      static_cast<std::size_t>(scene.width) * static_cast<std::size_t>(scene.height);
  framebuffer.assign(pixel_count, kClearColor);

  for (std::size_t tri_i = 0; tri_i < scene.triangle_count; ++tri_i) {
    const Triangle& tri = scene.triangles[tri_i];
    const std::int32_t v0x = to_q10_6(tri.v0x);
    const std::int32_t v0y = to_q10_6(tri.v0y);
    const std::int32_t v1x = to_q10_6(tri.v1x);
    const std::int32_t v1y = to_q10_6(tri.v1y);
    const std::int32_t v2x = to_q10_6(tri.v2x);
    const std::int32_t v2y = to_q10_6(tri.v2y);
    const std::uint32_t color = tri.color & 0x00FFFFFFu;

    for (int y = 0; y < scene.height; ++y) {
      for (int x = 0; x < scene.width; ++x) {
        const std::int32_t px = pixel_center_q(x);
        const std::int32_t py = pixel_center_q(y);
        if (is_inside(v0x, v0y, v1x, v1y, v2x, v2y, px, py)) {
          framebuffer[static_cast<std::size_t>(y) * scene.width +
                      static_cast<std::size_t>(x)] = color;
        }
      }
    }
  }
}

}  // namespace raster
