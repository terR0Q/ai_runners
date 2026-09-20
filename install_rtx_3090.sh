#!/bin/bash
apt update
apt install mc iftop tcpflow mtr git git-lfs cmake libcurl4-openssl-dev
cd /opt

echo "Installing llama.cpp server"

git clone https://github.com/ggml-org/llama.cpp
cd llama.cpp

cmake -B build \
  -DGGML_CUDA=ON \
  -DCMAKE_CUDA_ARCHITECTURES=86 \
  -DCMAKE_BUILD_TYPE=Release
cmake --build build --config Release --parallel 6 --clean-first

mkdir /srv/llama.models
# Download models
# GIT_LFS_SKIP_SMUDGE=1 git clone https://huggingface.co/unsloth/Qwen3.8-27B-GGUF
# cd Qwen3.8-27B-GGUF
# git lfs pull --include="Qwen3.8-27B-UD-Q4_K_M.gguf"
# git lfs pull --include="imatrix_unsloth.gguf"
# git lfs pull --include="mmproj-BF16.gguf"
# git lfs pull --include="mmproj-F16.gguf"
#
# /opt/llama.cpp/build/bin/llama-server \
#   -m /srv/llama.models/Qwen3.8-27B-GGUF/Qwen3.8-27B-UD-Q4_K_M.gguf \
#   --host 0.0.0.0 --port 11434 \
#   --api-key-file /etc/llama/api-keys \
#   -ngl 999 -fa on -np 1 \
#   -c 100000 -ctk q8_0 -ctv q8_0 \
#   --temp 1.0 --top-p 0.95 --top-k 20 --min-p 0 \
#   --threads 6 --jinja

SERVICE_FILE="llama-server-router.service"
DEST="/etc/systemd/system/${SERVICE_FILE}"

if [ ! -f "$SERVICE_FILE" ]; then
  echo "Error: $SERVICE_FILE not found in current directory."
  exit 1
fi

sudo cp "$SERVICE_FILE" "$DEST"
echo "Copied $SERVICE_FILE to $DEST"

echo "Making API folder"
mkdir -p /etc/llama

echo "Generating API key"
openssl rand -hex 32 > /etc/llama/api-keys

echo "Closing external ports leaving for wireguard access on wg0 network"
sudo ufw allow in on wg0 from 10.2.0.0/24 to any port 11434 proto tcp

sudo systemctl daemon-reload
echo "Reloaded systemd daemon"

sudo systemctl enable llama-server.service
echo "Enabled llama-server.service"

sudo systemctl start llama-server.service
echo "Started llama-server.service"

sudo systemctl status llama-server.service --no-pager

echo "Installing open-webui"
git clone git@github.com:open-webui/open-webui.git
bash update-open-webui.sh

echo "Open-webui ready"
