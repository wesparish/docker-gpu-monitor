#!/bin/bash

docker build -t wesparish/gpu-monitor:nvidia . && \
  docker tag wesparish/gpu-monitor:nvidia wesparish/gpu-monitor:nvidia && \
  docker push wesparish/gpu-monitor:nvidia
