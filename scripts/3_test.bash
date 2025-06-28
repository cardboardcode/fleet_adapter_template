#!/usr/bin/env bash

docker run -it --rm  \
    --name fleet_adapter_template_c \
    --network host \
    -v /dev/shm:/dev/shm \
fleet_adapter_template:jazzy bash -c "ros2 launch fleet_adapter_template run.launch.py \
    config_file:=/ros2_ws/src/fleet_adapter_template/config.yaml \
    navigation_graph_file:=/ros2_ws/src/fleet_adapter_template/0.yaml \
    server_uri:=ws://localhost:8000"
