// CUDA golden rasterizer twin.
// Same Q10.6 edge-function fill as RTL — not "hardware uses CUDA".

#include "rasterize.h"

#include <cuda_runtime.h>

#include <cstdio>
#include <stdexcept>
#include <string>

#include "edge.h"
#include "raster_params.h"

namespace raster {
namespace {

void check_cuda(cudaError_t err, const char* what) {
  if (err != cudaSuccess) {
    throw std::runtime_error(std::string(what) + ": " + cudaGetErrorString(err));
  }
}

__global__ void clear_framebuffer_kernel(std::uint32_t* fb, int pixel_count,
                                         std::uint32_t clear_color) {
  const int idx = blockIdx.x * blockDim.x + threadIdx.x;
  if (idx < pixel_count) {
    fb[idx] = clear_color;
  }
}

// One thread per pixel. Overwrite when inside (painter's algorithm).
__global__ void fill_triangle_kernel(std::uint32_t* fb, int width, int height,
                                     std::int32_t v0x, std::int32_t v0y,
                                     std::int32_t v1x, std::int32_t v1y,
                                     std::int32_t v2x, std::int32_t v2y,
                                     std::uint32_t color) {
  const int x = blockIdx.x * blockDim.x + threadIdx.x;
  const int y = blockIdx.y * blockDim.y + threadIdx.y;
  if (x >= width || y >= height) {
    return;
  }

  const std::int32_t px = (x << kFracBits) + kHalfPixel;
  const std::int32_t py = (y << kFracBits) + kHalfPixel;
  if (is_inside(v0x, v0y, v1x, v1y, v2x, v2y, px, py)) {
    fb[y * width + x] = color;
  }
}

}  // namespace

void rasterize_cuda(const Scene& scene, std::vector<std::uint32_t>& framebuffer) {
  if (scene.width <= 0 || scene.height <= 0) {
    throw std::runtime_error("rasterize_cuda: invalid scene dimensions");
  }
  if (scene.triangles == nullptr && scene.triangle_count > 0) {
    throw std::runtime_error("rasterize_cuda: null triangle list");
  }

  const int pixel_count = scene.width * scene.height;
  const std::size_t bytes =
      static_cast<std::size_t>(pixel_count) * sizeof(std::uint32_t);

  std::uint32_t* d_fb = nullptr;
  check_cuda(cudaMalloc(reinterpret_cast<void**>(&d_fb), bytes), "cudaMalloc");

  try {
    const int clear_threads = 256;
    const int clear_blocks = (pixel_count + clear_threads - 1) / clear_threads;
    clear_framebuffer_kernel<<<clear_blocks, clear_threads>>>(d_fb, pixel_count,
                                                              kClearColor);
    check_cuda(cudaGetLastError(), "clear_framebuffer_kernel launch");
    check_cuda(cudaDeviceSynchronize(), "clear_framebuffer_kernel sync");

    const dim3 block(kThreadsPerBlockX, kThreadsPerBlockY);
    const dim3 grid((scene.width + block.x - 1) / block.x,
                    (scene.height + block.y - 1) / block.y);

    for (std::size_t tri_i = 0; tri_i < scene.triangle_count; ++tri_i) {
      const Triangle& tri = scene.triangles[tri_i];
      const std::int32_t v0x = to_q10_6(tri.v0x);
      const std::int32_t v0y = to_q10_6(tri.v0y);
      const std::int32_t v1x = to_q10_6(tri.v1x);
      const std::int32_t v1y = to_q10_6(tri.v1y);
      const std::int32_t v2x = to_q10_6(tri.v2x);
      const std::int32_t v2y = to_q10_6(tri.v2y);
      const std::uint32_t color = tri.color & 0x00FFFFFFu;

      fill_triangle_kernel<<<grid, block>>>(d_fb, scene.width, scene.height, v0x,
                                            v0y, v1x, v1y, v2x, v2y, color);
      check_cuda(cudaGetLastError(), "fill_triangle_kernel launch");
      check_cuda(cudaDeviceSynchronize(), "fill_triangle_kernel sync");
    }

    framebuffer.resize(static_cast<std::size_t>(pixel_count));
    check_cuda(cudaMemcpy(framebuffer.data(), d_fb, bytes, cudaMemcpyDeviceToHost),
               "cudaMemcpy D2H");
  } catch (...) {
    cudaFree(d_fb);
    throw;
  }

  check_cuda(cudaFree(d_fb), "cudaFree");
}

}  // namespace raster
