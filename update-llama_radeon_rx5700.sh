#!/bin/bash
sudo systemctl stop llama-server
cd ~/loot/ai/llama.cpp
git pull
#cmake -B build -DGGML_CUDA=ON
export HSA_OVERRIDE_GFX_VERSION=10.1.0
cmake -B build \
  -DGGML_VULKAN=ON \
  -DGGML_CUDA=OFF \
  -DGGML_HIP=OFF
cmake --build build --config Release -j --clean-first
sudo systemctl start llama-server
