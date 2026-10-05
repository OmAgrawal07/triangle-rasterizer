#include <cstdlib>
#include <cstring>
#include <iostream>
#include <string>
#include <vector>

#include "rasterize.h"
#include "scenes.h"

namespace {

void print_usage(const char* argv0) {
  std::cerr
      << "CUDA/CPU golden rasterizer twin (bit-exact vs RTL fill rules)\n\n"
      << "Usage:\n"
      << "  " << argv0
      << " --scene {phase1|phase2|robot} [--backend cpu|cuda] "
         "[--out path.rgb] [--compare rtl.rgb]\n\n"
      << "Examples:\n"
      << "  " << argv0 << " --scene robot --backend cpu --out cuda/out/robot.rgb\n"
      << "  " << argv0
      << " --scene robot --backend cuda --out cuda/out/robot_cuda.rgb "
         "--compare sim/out/scene.rgb\n";
}

}  // namespace

int main(int argc, char** argv) {
  const char* scene_name = "robot";
  const char* backend = "cpu";
  std::string out_path;
  std::string compare_path;

  for (int i = 1; i < argc; ++i) {
    if (std::strcmp(argv[i], "--scene") == 0 && i + 1 < argc) {
      scene_name = argv[++i];
    } else if (std::strcmp(argv[i], "--backend") == 0 && i + 1 < argc) {
      backend = argv[++i];
    } else if (std::strcmp(argv[i], "--out") == 0 && i + 1 < argc) {
      out_path = argv[++i];
    } else if (std::strcmp(argv[i], "--compare") == 0 && i + 1 < argc) {
      compare_path = argv[++i];
    } else if (std::strcmp(argv[i], "-h") == 0 ||
               std::strcmp(argv[i], "--help") == 0) {
      print_usage(argv[0]);
      return 0;
    } else {
      std::cerr << "error: unknown argument: " << argv[i] << "\n";
      print_usage(argv[0]);
      return 2;
    }
  }

  const raster::Scene* scene = raster::find_scene(scene_name);
  if (scene == nullptr) {
    std::cerr << "error: unknown scene '" << scene_name
              << "' (use phase1, phase2, or robot)\n";
    return 2;
  }

  if (out_path.empty()) {
    out_path = std::string("cuda/out/") + scene->name + "_" + backend + ".rgb";
  }

  try {
    std::vector<std::uint32_t> framebuffer;
    if (std::strcmp(backend, "cpu") == 0) {
      raster::rasterize_cpu(*scene, framebuffer);
    } else if (std::strcmp(backend, "cuda") == 0) {
#ifdef RASTER_HAS_CUDA
      raster::rasterize_cuda(*scene, framebuffer);
#else
      std::cerr << "error: this binary was built without CUDA "
                   "(make golden_cuda on a machine with nvcc)\n";
      return 2;
#endif
    } else {
      std::cerr << "error: unknown backend '" << backend
                << "' (use cpu or cuda)\n";
      return 2;
    }

    raster::write_rgb888(out_path, framebuffer, scene->width, scene->height);
    std::cout << "wrote " << out_path << " (" << scene->width << "x"
              << scene->height << ", " << scene->triangle_count
              << " triangles, backend=" << backend << ")\n";

    if (!compare_path.empty()) {
      const bool ok =
          raster::compare_rgb888(out_path, compare_path, scene->width,
                                 scene->height);
      return ok ? 0 : 1;
    }
    return 0;
  } catch (const std::exception& ex) {
    std::cerr << "error: " << ex.what() << "\n";
    return 1;
  }
}
