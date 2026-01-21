# Docker Deployment Guide for Ovi

## Prerequisites
- Docker with GPU support (nvidia-docker2)
- NVIDIA GPU with 24GB+ VRAM
- Docker Compose v3.8+

## Quick Start

### 1. Download Models
```bash
docker-compose --profile download up ovi-download
```

### 2. Run Gradio Web Interface
```bash
# Standard (requires 80GB VRAM)
docker-compose --profile gradio up ovi-gradio

# Low VRAM mode (24GB VRAM)
docker-compose --profile low-vram up ovi-gradio-low-vram
```

### 3. Run CLI Inference
```bash
# Single GPU
docker-compose --profile inference up ovi-inference

# Multi-GPU
docker-compose --profile multi-gpu up ovi-inference-multi
```

## Build Individual Images

### Base Image
```bash
docker build -f Dockerfile.base -t ovi:base .
```

### Inference Image
```bash
docker build -f Dockerfile.inference -t ovi:inference .
```

### Gradio Image
```bash
docker build -f Dockerfile.gradio -t ovi:gradio .
```

## Manual Docker Run

### Download Models
```bash
docker run --rm -v $(pwd)/ckpts:/app/ckpts ovi:download
```

### Run Gradio (Low VRAM)
```bash
docker run --gpus all -p 7891:7891 \
  -v $(pwd)/ckpts:/app/ckpts \
  -v $(pwd)/outputs:/app/outputs \
  ovi:gradio python3 gradio_app.py --server_name 0.0.0.0 --cpu_offload --fp8
```

### Run Inference
```bash
docker run --gpus all \
  -v $(pwd)/ckpts:/app/ckpts \
  -v $(pwd)/outputs:/app/outputs \
  ovi:inference
```

## Configuration

### GPU Memory Options
- **80GB VRAM**: Standard mode
- **24GB VRAM**: Use `--cpu_offload --fp8` flags
- **Multi-GPU**: Set `CUDA_VISIBLE_DEVICES` and use torchrun

### Volume Mounts
- `/app/ckpts`: Model checkpoints
- `/app/outputs`: Generated videos
- `/app/ovi/configs`: Configuration files

## Troubleshooting

### GPU Not Detected
```bash
# Check GPU support
docker run --rm --gpus all nvidia/cuda:12.1-base nvidia-smi
```

### Out of Memory
- Use low VRAM profile
- Reduce batch size in config
- Enable CPU offload

### Model Download Issues
- Check internet connection
- Verify HuggingFace access
- Use manual wget for fp8 models