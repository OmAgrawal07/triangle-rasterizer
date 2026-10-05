#ifndef SCENES_H
#define SCENES_H

#include "triangle.h"

namespace raster {

// Phase 1 single-triangle TB (tb_raster_triangle.sv).
const Scene& scene_phase1();

// Phase 2 two-triangle overlap (historical scene from Phase 2 commit).
const Scene& scene_phase2();

// Phase 3 cartoon robot — mirrors rtl/triangle_rom.sv (66 triangles, 128x128).
const Scene& scene_robot();

const Scene* find_scene(const char* name);

}  // namespace raster

#endif  // SCENES_H
