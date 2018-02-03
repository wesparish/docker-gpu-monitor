#!/bin/bash

docker build -t wesparish/gpu-monitor:1.2 . && \
  docker push wesparish/gpu-monitor:1.2
