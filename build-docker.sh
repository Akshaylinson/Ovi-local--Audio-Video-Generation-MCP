#!/bin/bash
# Build script for Ovi Docker images

set -e

echo "🐳 Building Ovi Docker Images..."

# Build base image
echo "📦 Building base image..."
docker build -f Dockerfile.base -t ovi:base .

# Build download image
echo "📥 Building download image..."
docker build -f Dockerfile.download -t ovi:download .

# Build inference image
echo "🚀 Building inference image..."
docker build -f Dockerfile.inference -t ovi:inference .

# Build gradio image
echo "🌐 Building gradio image..."
docker build -f Dockerfile.gradio -t ovi:gradio .

echo "✅ All images built successfully!"
echo ""
echo "Available images:"
docker images | grep ovi

echo ""
echo "🎯 Quick start commands:"
echo "  Download models: docker-compose --profile download up"
echo "  Run Gradio (24GB): docker-compose --profile low-vram up"
echo "  Run inference: docker-compose --profile inference up"