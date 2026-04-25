sudo systemctl stop llama-server
cd llama.cpp
git pull
#cmake -B build -DGGML_CUDA=ON
cmake -B build \
  -DGGML_CUDA=ON \
  -DCMAKE_CUDA_ARCHITECTURES=61 \
  -DGGML_CUDA_FORCE_MMQ=OFF
cmake --build build --config Release -j2 --clean-first
sudo systemctl start llama-server
