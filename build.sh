#!/bin/bash

docker build -t wesparish/gpu-monitor . && \
  docker push wesparish/gpu-monitor
