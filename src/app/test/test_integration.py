import os
import sys
import time
import unittest

import rclpy
from turtlesim.msg import Pose

import launch
import launch_ros
import launch_testing.actions


def generate_test_description():
    return (
        launch.LaunchDescription(
            [
                # Nodes under test
                # Can also reference here to a launch file in `app/launch`
                # to avoid duplication
                # Just a simple node here, yet can launch anything, e.g. Gazebo
                launch_ros.actions.Node(
                    package='turtlesim',
                    namespace='',
                    executable='turtlesim_node',
                    name='turtle1',
                ),
                # Launch tests 0.5 s later
                launch.actions.TimerAction(
                    period=0.5, actions=[launch_testing.actions.ReadyToTest()]),
            ]
        ),
        # context
        {
        },
    )


# Active tests
class TestTurtleSim(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        rclpy.init()

    @classmethod
    def tearDownClass(cls):
        rclpy.shutdown()

    def setUp(self):
        self.node = rclpy.create_node('test_turtlesim')

    def tearDown(self):
        self.node.destroy_node()

    def test_logs_spawning(self, proc_output):
        """Check whether logging properly"""
        proc_output.assertWaitFor(
            'Spawning turtle [turtle1] at x=',
            timeout=15, stream='stderr')

    def test_publishes_pose(self, proc_output):
        """Check whether pose messages published"""
        msgs_rx = []
        sub = self.node.create_subscription(
            Pose, 'turtle1/pose',
            lambda msg: msgs_rx.append(msg), 10)
        try:
            end_time = time.time() + 10
            while time.time() < end_time:
                rclpy.spin_once(self.node, timeout_sec=1)
                if len(msgs_rx) > 30:
                    break
            self.assertGreater(len(msgs_rx), 30)
        finally:
            self.node.destroy_subscription(sub)


# Post-shutdown tests
@launch_testing.post_shutdown_test()
class TestTurtleSimShutdown(unittest.TestCase):
    def test_exit_codes(self, proc_info):
        """Check if the processes exited normally."""
        launch_testing.asserts.assertExitCodes(proc_info)
