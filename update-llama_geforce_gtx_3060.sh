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

# Fedora / SUSE linux to allow service run:
sudo semanage fcontext -a -t bin_t "/home/terr0q/loot/ai/llama.cpp/build/bin/llama-server"
sudo restorecon -v /home/terr0q/loot/ai/llama.cpp/build/bin/llama-server