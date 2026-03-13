#!/bin/bash
echo "Installing llama.cpp server"

git clone git@github.com:ggml-org/llama.cpp.git
cd llama.cpp

cmake -B build \
  -DGGML_CUDA=ON \
  -DCMAKE_CUDA_ARCHITECTURES=61 \
  -DGGML_CUDA_FORCE_MMQ=OFF
cmake --build build --config Release -j --clean-first

cd ..

SERVICE_FILE="llama-server.service"
DEST="/etc/systemd/system/${SERVICE_FILE}"

if [ ! -f "$SERVICE_FILE" ]; then
  echo "Error: $SERVICE_FILE not found in current directory."
  exit 1
fi

sudo cp "$SERVICE_FILE" "$DEST"
echo "Copied $SERVICE_FILE to $DEST"

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