#!/bin/bash
sudo systemctl stop llama-server
cd llama.cpp
git pull
rm -rf build
cmake -B build \
  -DGGML_CUDA=ON \
  -DGGML_VULKAN=OFF \
  -DGGML_HIP=OFF \
  -DCMAKE_CUDA_FLAGS="-allow-unsupported-compiler"
cmake --build build --config Release -j --clean-first