#!/bin/bash

docker build -t wesparish/gpu-monitor:1.1 . && \
  docker push wesparish/gpu-monitor:1.1
