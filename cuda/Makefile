# Golden rasterizer twin — CPU always; CUDA when nvcc is available.
#
#   make              # build cpu binary
#   make golden_cuda  # build cuda binary (requires CUDA toolkit)
#   make run_robot    # render robot scene on CPU → cuda/out/
#   make selftest     # cpu render + cpu/cpu compare smoke

CXX      ?= g++
NVCC     ?= nvcc
CXXFLAGS ?= -std=c++17 -O2 -Wall -Wextra -Iinclude
NVCCFLAGS ?= -std=c++17 -O2 -Iinclude -DRASTER_HAS_CUDA

SRC_COMMON := src/scenes.cpp src/rasterize_cpu.cpp src/io.cpp src/main.cpp
OUT_DIR    := out

.PHONY: all golden_cpu golden_cuda run_robot run_phase1 selftest clean

all: golden_cpu

golden_cpu: bin/golden_cpu
	@true

bin/golden_cpu: $(SRC_COMMON) include/*.h
	mkdir -p bin $(OUT_DIR)
	$(CXX) $(CXXFLAGS) -o $@ $(SRC_COMMON)

golden_cuda: bin/golden_cuda
	@true

bin/golden_cuda: $(SRC_COMMON) src/rasterize.cu include/*.h
	mkdir -p bin $(OUT_DIR)
	@command -v $(NVCC) >/dev/null 2>&1 || { \
	  echo "error: $(NVCC) not found — install CUDA toolkit, or use 'make golden_cpu'"; \
	  exit 1; \
	}
	$(NVCC) $(NVCCFLAGS) -o $@ $(SRC_COMMON) src/rasterize.cu

run_robot: bin/golden_cpu
	./bin/golden_cpu --scene robot --backend cpu --out $(OUT_DIR)/robot_cpu.rgb
	python3 ../scripts/dump_to_png.py $(OUT_DIR)/robot_cpu.rgb $(OUT_DIR)/robot_cpu.png \
	  --width 128 --height 128

run_phase1: bin/golden_cpu
	./bin/golden_cpu --scene phase1 --backend cpu --out $(OUT_DIR)/phase1_cpu.rgb
	python3 ../scripts/dump_to_png.py $(OUT_DIR)/phase1_cpu.rgb $(OUT_DIR)/phase1_cpu.png \
	  --width 128 --height 128

# CPU vs CPU identity check (no GPU / no RTL required).
selftest: bin/golden_cpu
	./bin/golden_cpu --scene robot --backend cpu --out $(OUT_DIR)/robot_a.rgb
	./bin/golden_cpu --scene robot --backend cpu --out $(OUT_DIR)/robot_b.rgb
	./bin/golden_cpu --scene robot --backend cpu --out $(OUT_DIR)/robot_a.rgb \
	  --compare $(OUT_DIR)/robot_b.rgb
	./bin/golden_cpu --scene phase1 --backend cpu --out $(OUT_DIR)/phase1_a.rgb
	./bin/golden_cpu --scene phase1 --backend cpu --out $(OUT_DIR)/phase1_b.rgb \
	  --compare $(OUT_DIR)/phase1_a.rgb
	@echo "selftest: PASS"

# Diff golden against an RTL dump (after ./sim/run_scene.sh).
compare_rtl_robot: bin/golden_cpu
	./bin/golden_cpu --scene robot --backend cpu --out $(OUT_DIR)/robot_cpu.rgb \
	  --compare ../sim/out/scene.rgb

clean:
	rm -rf bin $(OUT_DIR)/*.rgb $(OUT_DIR)/*.png
