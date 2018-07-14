#!/bin/bash

docker build -t wesparish/gpu-monitor:1.3 . && \
  docker push wesparish/gpu-monitor:1.3
