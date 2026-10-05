#include "scenes.h"

#include <cstring>

namespace raster {
namespace {

// Integer pixel verts — same as TB/ROM before <<< FRAC_BITS.
const Triangle kPhase1Tris[] = {
    {10, 10, 30, 40, 50, 10, 0x39C6EDu},
};

const Triangle kPhase2Tris[] = {
    {10, 10, 42, 48, 54, 10, 0x39C6EDu},
    {20, 20, 28, 26, 32, 20, 0xFF00FFu},
};

// Mirrors rtl/triangle_rom.sv case table (parsed from SV; keep in sync).
const Triangle kRobotTris[] = {
    {38, 12, 38, 52, 90, 12, 0x1A5276u},
    {90, 12, 38, 52, 90, 52, 0x1A5276u},
    {42, 16, 42, 48, 86, 16, 0x5DADE2u},
    {86, 16, 42, 48, 86, 48, 0x5DADE2u},
    {48, 4, 48, 12, 80, 4, 0x5D6D7Eu},
    {80, 4, 48, 12, 80, 12, 0x5D6D7Eu},
    {50, 5, 50, 11, 56, 5, 0xFF69B4u},
    {56, 5, 50, 11, 56, 11, 0xFF69B4u},
    {58, 5, 58, 11, 64, 5, 0xF4D03Fu},
    {64, 5, 58, 11, 64, 11, 0xF4D03Fu},
    {66, 5, 66, 11, 72, 5, 0xFF69B4u},
    {72, 5, 66, 11, 72, 11, 0xFF69B4u},
    {74, 5, 74, 11, 80, 5, 0xF4D03Fu},
    {80, 5, 74, 11, 80, 11, 0xF4D03Fu},
    {22, 24, 22, 44, 42, 24, 0xF4D03Fu},
    {42, 24, 22, 44, 42, 44, 0xF4D03Fu},
    {86, 24, 86, 44, 106, 24, 0xF4D03Fu},
    {106, 24, 86, 44, 106, 44, 0xF4D03Fu},
    {50, 26, 50, 40, 58, 26, 0x1C2833u},
    {58, 26, 50, 40, 58, 40, 0x1C2833u},
    {70, 26, 70, 40, 78, 26, 0x1C2833u},
    {78, 26, 70, 40, 78, 40, 0x1C2833u},
    {52, 28, 52, 34, 56, 28, 0xFDFEFEu},
    {72, 28, 72, 34, 76, 28, 0xFDFEFEu},
    {54, 42, 54, 46, 74, 42, 0x1C2833u},
    {74, 42, 54, 46, 74, 46, 0x1C2833u},
    {56, 48, 56, 58, 72, 48, 0x95A5A6u},
    {72, 48, 56, 58, 72, 58, 0x95A5A6u},
    {42, 56, 42, 96, 86, 56, 0x1A5276u},
    {86, 56, 42, 96, 86, 96, 0x1A5276u},
    {46, 60, 46, 92, 82, 60, 0x5DADE2u},
    {82, 60, 46, 92, 82, 92, 0x5DADE2u},
    {52, 72, 52, 80, 60, 72, 0xFF69B4u},
    {60, 72, 52, 80, 60, 80, 0xFF69B4u},
    {62, 72, 62, 80, 70, 72, 0xF4D03Fu},
    {70, 72, 62, 80, 70, 80, 0xF4D03Fu},
    {72, 72, 72, 80, 80, 72, 0x9B59B6u},
    {80, 72, 72, 80, 80, 80, 0x9B59B6u},
    {30, 64, 30, 76, 46, 64, 0x95A5A6u},
    {46, 64, 30, 76, 46, 76, 0x95A5A6u},
    {82, 64, 82, 76, 98, 64, 0x95A5A6u},
    {98, 64, 82, 76, 98, 76, 0x95A5A6u},
    {28, 76, 28, 104, 44, 76, 0x5DADE2u},
    {44, 76, 28, 104, 44, 104, 0x5DADE2u},
    {84, 76, 84, 104, 100, 76, 0x5DADE2u},
    {100, 76, 84, 104, 100, 104, 0x5DADE2u},
    {28, 104, 28, 110, 44, 104, 0x5D6D7Eu},
    {44, 104, 28, 110, 44, 110, 0x5D6D7Eu},
    {84, 104, 84, 110, 100, 104, 0x5D6D7Eu},
    {100, 104, 84, 110, 100, 110, 0x5D6D7Eu},
    {24, 110, 24, 122, 48, 110, 0x95A5A6u},
    {48, 110, 24, 122, 48, 122, 0x95A5A6u},
    {80, 110, 80, 122, 104, 110, 0x95A5A6u},
    {104, 110, 80, 122, 104, 122, 0x95A5A6u},
    {50, 92, 50, 102, 60, 92, 0x95A5A6u},
    {60, 92, 50, 102, 60, 102, 0x95A5A6u},
    {68, 92, 68, 102, 78, 92, 0x95A5A6u},
    {78, 92, 68, 102, 78, 102, 0x95A5A6u},
    {48, 102, 48, 116, 62, 102, 0x5DADE2u},
    {62, 102, 48, 116, 62, 116, 0x5DADE2u},
    {66, 102, 66, 116, 80, 102, 0x5DADE2u},
    {80, 102, 66, 116, 80, 116, 0x5DADE2u},
    {42, 116, 42, 126, 64, 116, 0xF4D03Fu},
    {64, 116, 42, 126, 64, 126, 0xF4D03Fu},
    {64, 116, 64, 126, 86, 116, 0xF4D03Fu},
    {86, 116, 64, 126, 86, 126, 0xF4D03Fu},
};

const Scene kPhase1 = {
    "phase1",
    128,
    128,
    kPhase1Tris,
    sizeof(kPhase1Tris) / sizeof(kPhase1Tris[0]),
};

// Phase 2 shipped at 64x64; keep that footprint for historical overlap check.
const Scene kPhase2 = {
    "phase2",
    64,
    64,
    kPhase2Tris,
    sizeof(kPhase2Tris) / sizeof(kPhase2Tris[0]),
};

const Scene kRobot = {
    "robot",
    128,
    128,
    kRobotTris,
    sizeof(kRobotTris) / sizeof(kRobotTris[0]),
};

}  // namespace

const Scene& scene_phase1() { return kPhase1; }
const Scene& scene_phase2() { return kPhase2; }
const Scene& scene_robot() { return kRobot; }

const Scene* find_scene(const char* name) {
  if (std::strcmp(name, "phase1") == 0) {
    return &kPhase1;
  }
  if (std::strcmp(name, "phase2") == 0) {
    return &kPhase2;
  }
  if (std::strcmp(name, "robot") == 0 || std::strcmp(name, "phase3") == 0) {
    return &kRobot;
  }
  return nullptr;
}

}  // namespace raster
