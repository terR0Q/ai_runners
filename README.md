# Setup
Prerequisites:
1. Some linux OS, debian used as a model here with systemd used for service running.
2. git and lfs (`git lfs install`)
3. docker

To setup local AI you first need to get a model from https://huggingface.co/ in GGUF file.
For example as provided in local llama-service file:
```shell
GIT_LFS_SKIP_SMUDGE=1 git clone https://huggingface.co/Triangle104/Qwen2.5-Coder-7B-Instruct-Q4_K_M-GGUF
cd Qwen2.5-Coder-7B-Instruct-Q4_K_M-GGUF/
git lfs pull --include="qwen2.5-coder-7b-instruct-q4_k_m.gguf"
```

# Update
Open-WebUI and llama.cpp are actively developed at the moment. Open-WebUI will tell you about new version itself,
then just run `bash update-open-webui.sh` for upgrade.
llama.cpp is a silent tool and you'll never know of any update. But they are there almost daily. Run `bash update-llama.sh`.

# GPU specifics
llama.cpp scripts here (install and update) are tuned for Nvidia GTX 1060 with just 1 Gi of RAM. Plus it's a CUDA build.
Change update script for building server for current GPU specifics.
