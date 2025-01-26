# ROS 2 Integration and Unit Testing Examples
An example package `app` that showcases
integration testing with `launch_testing` and `ament_cmake_ros`
and unit testing with `pytest` and `gtest`.

Both integration and unit tests write out **complete XUnit reports**,
allowing to list the results of all individual tests together
(e.g. to create a report as part of a CI/CD pipeline).
Also, each integration test automatically receives a unique `ROS_DOMAIN_ID`
to avoid crosstalk between simultaneously running tests.

A ROS 2 Jazzy Docker setup is included to get started quickly.
This code probably also works on Humble and Iron.
Please see the instructions further on for creating the `.env` file.

For more documentation, please have a look at the code files
in the `app` package such as
[test_integration.py](src/app/test/test_integration.py)
and the [CMakeLists.txt](src/app/CMakeLists.txt)


## Get up and running
```bash
git clone git@github.com:abaeyens/ros2-integration-testing-examples.git
cd ros2-integration-testing-examples

echo -e USER_ID=$(id -u $USER)\\nGROUP_ID=$(id -g $USER) >> .env
docker compose build --pull
docker compose run --rm app bash

colcon build
source install/setup.bash
colcon test --event-handlers console_direct+
colcon test-result --all
xunit-viewer -r build/app/test_results -c
```

## Notes
- The tests include launching a turtlesim GUI,
  hence the tests may fail on a headless system.
