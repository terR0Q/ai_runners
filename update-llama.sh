sudo systemctl stop llama-server
cd llama.cpp
git pull
#cmake -B build -DGGML_CUDA=ON
cmake -B build
cmake --build build --config Release -j --clean-first
sudo systemctl start llama-server
