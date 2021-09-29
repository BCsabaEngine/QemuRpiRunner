#!/bin/bash
KERNEL_IMAGE_NAME="qemurpirunner/builder:latest"
PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)/./"
DIST_DIR="$PROJECT_DIR/dist"

mkdir -p $DIST_DIR

docker run --rm -it -v $DIST_DIR:/export $KERNEL_IMAGE_NAME "$@"
