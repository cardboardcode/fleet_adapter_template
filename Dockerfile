FROM ros:jazzy-ros-base
ENV DEBIAN_FRONTEND=noninteractive
ENV RMF2_WS=/ros2_ws

RUN apt-get update && apt-get install -y \
    ros-jazzy-rmf-dev \
    build-essential \
    python3-rosdep \
    python3-pip \
  && pip3 install --break-system-packages flask-socketio fastapi uvicorn nudged \
  && rm -rf /var/lib/apt/lists/*

# Install dependencies
WORKDIR /ros2_ws
COPY fleet_adapter_template src/fleet_adapter_template
RUN apt-get update \
    && rosdep install --from-paths src --ignore-src --rosdistro $ROS_DISTRO -yr \
    && rm -rf /var/lib/apt/lists/*

# Build fleet_adapter_template package.
RUN . /opt/ros/$ROS_DISTRO/setup.sh \
  && colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release

# Add to source.
RUN sed -i '$isource "/$RMF2_WS/install/setup.bash"' /ros_entrypoint.sh

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ros2 run fleet_adapter_template fleet_adapter -c /ros2_ws/src/fleet_adapter_template/config.yaml -n /ros2_ws/src/fleet_adapter_template/0.yaml -s ws://localhost:8000
