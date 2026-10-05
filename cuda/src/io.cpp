#include "rasterize.h"

#include <cstdio>
#include <fstream>
#include <iostream>
#include <stdexcept>
#include <vector>

#include "raster_params.h"

namespace raster {

void write_rgb888(const std::string& path, const std::vector<std::uint32_t>& fb,
                  int width, int height) {
  const std::size_t expected =
      static_cast<std::size_t>(width) * static_cast<std::size_t>(height);
  if (fb.size() != expected) {
    throw std::runtime_error("write_rgb888: framebuffer size mismatch");
  }

  std::ofstream out(path, std::ios::binary);
  if (!out) {
    throw std::runtime_error("write_rgb888: could not open " + path);
  }

  for (std::uint32_t pixel : fb) {
    const unsigned char bytes[3] = {color_r(pixel), color_g(pixel), color_b(pixel)};
    out.write(reinterpret_cast<const char*>(bytes), 3);
  }
  if (!out) {
    throw std::runtime_error("write_rgb888: write failed for " + path);
  }
}

bool compare_rgb888(const std::string& path_a, const std::string& path_b,
                    int width, int height) {
  const std::size_t expected_bytes =
      static_cast<std::size_t>(width) * static_cast<std::size_t>(height) * 3u;

  auto load = [&](const std::string& path) {
    std::ifstream in(path, std::ios::binary);
    if (!in) {
      throw std::runtime_error("compare_rgb888: could not open " + path);
    }
    std::vector<unsigned char> data(expected_bytes);
    in.read(reinterpret_cast<char*>(data.data()),
            static_cast<std::streamsize>(expected_bytes));
    if (static_cast<std::size_t>(in.gcount()) != expected_bytes) {
      throw std::runtime_error("compare_rgb888: short read from " + path);
    }
    return data;
  };

  const std::vector<unsigned char> a = load(path_a);
  const std::vector<unsigned char> b = load(path_b);

  std::size_t mismatches = 0;
  std::size_t first_idx = 0;
  bool found = false;
  for (std::size_t i = 0; i < expected_bytes; i += 3) {
    if (a[i] != b[i] || a[i + 1] != b[i + 1] || a[i + 2] != b[i + 2]) {
      if (!found) {
        first_idx = i / 3;
        found = true;
      }
      ++mismatches;
    }
  }

  const std::size_t total_pixels = expected_bytes / 3;
  if (mismatches == 0) {
    std::cout << "compare_rgb888: PASS — " << total_pixels
              << " pixels match (" << path_a << " vs " << path_b << ")\n";
    return true;
  }

  const int fx = static_cast<int>(first_idx % static_cast<std::size_t>(width));
  const int fy = static_cast<int>(first_idx / static_cast<std::size_t>(width));
  const std::size_t bi = first_idx * 3;
  std::cout << "compare_rgb888: FAIL — " << mismatches << "/" << total_pixels
            << " pixels differ\n";
  std::printf("  first mismatch at (%d,%d): A=%02X%02X%02X B=%02X%02X%02X\n", fx, fy,
              a[bi], a[bi + 1], a[bi + 2], b[bi], b[bi + 1], b[bi + 2]);
  const double match_rate =
      100.0 * static_cast<double>(total_pixels - mismatches) /
      static_cast<double>(total_pixels);
  std::printf("  match rate: %.4f%%\n", match_rate);
  return false;
}

}  // namespace raster
