FROM ghcr.io/open-rmf/rmf/rmf_demos:latest

RUN apt-get update \
  && apt-get install -y \
    cmake \
    curl \
    git \
    python3-colcon-common-extensions \
    python3-vcstool \
    qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools \
    wget \
    python3-pip \
  && pip3 install flask-socketio fastapi uvicorn nudged \
  && rm -rf /var/lib/apt/lists/*

# setup keys
WORKDIR /fleet_adapter_ws
COPY . src
RUN rosdep update --rosdistro $ROS_DISTRO

# This replaces: wget https://raw.githubusercontent.com/open-rmf/rmf/main/rmf.repos
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get upgrade -y \
    && rosdep update \
    && rosdep install --from-paths src --ignore-src --rosdistro $ROS_DISTRO -yr \
    && rm -rf /var/lib/apt/lists/*

# colcon compilation
RUN . /opt/ros/$ROS_DISTRO/setup.sh \
  && colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release

# cleanup
RUN sed -i '$isource "/fleet_adapter_ws/install/setup.bash"' /ros_entrypoint.sh

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ros2 run fleet_adapter_template fleet_adapter -c /fleet_adapter_ws/src/fleet_adapter_template/config.yaml -n /fleet_adapter_ws/src/fleet_adapter_template/0.yaml -s ws://localhost:8000
