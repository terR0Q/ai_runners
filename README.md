# Setup
Prerequisites:
1. Some linux OS, debian used as a model here with systemd used for service running.
2. git and lfs (`git lfs install`)
3. docker
4. cmake
5. CUDA or ROCm components for your GPU

To set up local AI you first need to get a model from https://huggingface.co/ in GGUF file.
For example as provided in local llama-service file:
```shell
GIT_LFS_SKIP_SMUDGE=1 git clone https://huggingface.co/Triangle104/Qwen2.5-Coder-7B-Instruct-Q4_K_M-GGUF
cd Qwen2.5-Coder-7B-Instruct-Q4_K_M-GGUF/
git lfs pull --include="qwen2.5-coder-7b-instruct-q4_k_m.gguf"
```

Update llama server and selected model paths in `llama-server.service` before installation.
You can tune model parameters running
```shell
/home/user/llama.cpp/build/bin/llama-server\
        -m /home/user/llama.models/path_to/model.gguf
         --port 11434 --host 0.0.0.0 -ngl 28 -c 8096 -fa 0 --threads 6
```
before starting a service and always change horses later :)

# Update
Open-WebUI and llama.cpp are actively developed at the moment. Open-WebUI will tell you about new version itself,
then just run `bash update-open-webui.sh` for upgrade.
llama.cpp is a silent tool and you'll never know of any update. But they are there almost daily. Run `bash update-llama.sh`.

# GPU nuances
llama.cpp scripts here (install and update) are tuned for Nvidia GTX 1060 with just 1 Gi of RAM. Plus it's a CUDA build.
Change update script for building server for current GPU specifics.

## ROCm
For non-CUDA cards with ROCm build llama.cpp in `install.sh` and `update-llama.sh` with:
```shell
cmake -B build \
  -DGGML_CUDA=OFF \
  -DGGML_HIP=ON \
  -DAMDGPU_TARGETS=gfx1010 \
  -DGGML_HIP_FORCE_MMQ=OFF
```

### Debian ROCm
NOT TESTED yet:
```shell
sudo apt install rocm-hip-sdk rocm-libs hip-runtime-amd hipblas rocblas
```
### Fedora ROCm
Fedora 43 ROCm installation is harder:
```shell
sudo dnf install https://repo.radeon.com/amdgpu-install/6.2.3/rhel/9.3/amdgpu-install-6.2.60203-1.el9.noarch.rpm
sudo amdgpu-install --usecase=rocm,hip --no-dkms
sudo rm -f /etc/yum.repos.d/amdgpu*.repo
sudo dnf install rocm-cmake rocm-hip-devel rocm-comgr-devel
sudo dnf install hipblas rocblas hipblas-devel rocblas-devel
```

Validate installation:
```shell
hipcc --version
rocminfo | grep gfx1010
```

Update environment:
```shell
export HSA_OVERRIDE_GFX_VERSION=10.1.0
export PATH=/opt/rocm/bin:$PATH
```