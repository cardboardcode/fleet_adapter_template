#!/usr/bin/env bash

docker run -it --rm  \
    --name fleet_adapter_template_c \
    --network host \
    -v /dev/shm:/dev/shm \
fleet_adapter_template:jazzy bash -c "ros2 run fleet_adapter_template fleet_adapter \
    -c /ros2_ws/src/fleet_adapter_template/config.yaml \
    -n /ros2_ws/src/fleet_adapter_template/0.yaml \
    -s ws://localhost:8000"
