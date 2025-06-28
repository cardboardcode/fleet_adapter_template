#!/usr/bin/env python3

from launch import LaunchDescription
from launch.actions import DeclareLaunchArgument
from launch.substitutions import LaunchConfiguration
from launch_ros.actions import Node

def generate_launch_description():
    return LaunchDescription([
        DeclareLaunchArgument(
            'navigation_graph_file',
            description='The .yaml file that provides RMF waypoint information for setting up the adapter'
        ),
        DeclareLaunchArgument(
            'config_file',
            description='The config file that provides important parameters for setting up the adapter'
        ),
        DeclareLaunchArgument(
            'server_uri',
            description='The IP:Port address that points to the RMF API Server trajectory server for setting up the adapter'
        ),
        DeclareLaunchArgument(
            'output',
            default_value='screen',
            description='The output type of the nodes (screen, log)'
        ),
        Node(
            package='fleet_adapter_template',
            executable='fleet_adapter',
            arguments=[
                '--nav_graph', LaunchConfiguration('navigation_graph_file'),
                '--config_file', LaunchConfiguration('config_file'),
                '--server_uri', LaunchConfiguration('server_uri')],
            output='both',
            emulate_tty=True
        ),
    ])
