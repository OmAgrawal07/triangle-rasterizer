// Shared constants mirroring rtl/pkg_raster_params.sv + docs/rules-sheet.md.
// CUDA golden twin — not used by the hardware; used to verify RTL output.

#ifndef RASTER_PARAMS_H
#define RASTER_PARAMS_H

#include <cstdint>

namespace raster {

constexpr int kDefaultWidth = 128;
constexpr int kDefaultHeight = 128;
constexpr int kFracBits = 6;
constexpr int kHalfPixel = 1 << (kFracBits - 1);  // 32
constexpr std::uint32_t kClearColor = 0x202020u;
constexpr int kThreadsPerBlockX = 16;
constexpr int kThreadsPerBlockY = 16;

inline constexpr std::int32_t to_q10_6(int integer_pixel) {
  return static_cast<std::int32_t>(integer_pixel) << kFracBits;
}

inline constexpr std::int32_t pixel_center_q(int integer_pixel) {
  return to_q10_6(integer_pixel) + kHalfPixel;
}

inline constexpr std::uint8_t color_r(std::uint32_t rgb) {
  return static_cast<std::uint8_t>((rgb >> 16) & 0xFFu);
}

inline constexpr std::uint8_t color_g(std::uint32_t rgb) {
  return static_cast<std::uint8_t>((rgb >> 8) & 0xFFu);
}

inline constexpr std::uint8_t color_b(std::uint32_t rgb) {
  return static_cast<std::uint8_t>(rgb & 0xFFu);
}

}  // namespace raster

#endif  // RASTER_PARAMS_H
