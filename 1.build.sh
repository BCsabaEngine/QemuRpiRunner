#!/bin/bash

BUILDER_IMAGE_NAME="qemurpirunner/builder"
PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)/./"

docker build -t $BUILDER_IMAGE_NAME:latest $PROJECT_DIR $1
