#ifndef RASTERIZE_H
#define RASTERIZE_H

#include <cstdint>
#include <string>
#include <vector>

#include "triangle.h"

namespace raster {

// Painter's algorithm: clear once, then overwrite per triangle in order.
// Framebuffer packing matches RTL: one uint32_t per pixel, RGB in low 24 bits.
void rasterize_cpu(const Scene& scene, std::vector<std::uint32_t>& framebuffer);

#ifdef RASTER_HAS_CUDA
// Same algorithm on device; copy-back into host framebuffer.
// Throws std::runtime_error on CUDA API failure.
void rasterize_cuda(const Scene& scene, std::vector<std::uint32_t>& framebuffer);
#endif

void write_rgb888(const std::string& path, const std::vector<std::uint32_t>& fb,
                  int width, int height);

// Returns true if files are identical. On mismatch, prints first differing pixel.
bool compare_rgb888(const std::string& path_a, const std::string& path_b,
                    int width, int height);

}  // namespace raster

#endif  // RASTERIZE_H
