#!/bin/bash
cd ~/open-webui
git pull
sudo docker rm -f open-webui
sudo docker pull ghcr.io/open-webui/open-webui:main
sudo docker stop -f open-webui
sudo docker rm -f open-webui

sudo docker run --pull=always -d -p 3000:8080   --add-host=host.docker.internal:host-gateway \
          -v ~/Documents/open-webui:/app/backend/data   --name open-webui  ghcr.io/open-webui/open-webui:main