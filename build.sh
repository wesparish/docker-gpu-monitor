#!/bin/bash

docker build -t wesparish/gpu-monitor:latest . && \
  docker push wesparish/gpu-monitor:latest
