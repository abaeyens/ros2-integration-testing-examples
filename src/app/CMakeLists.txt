cmake_minimum_required(VERSION 3.8)
project(app)

find_package(ament_cmake REQUIRED)


#########
# build #
#########


###########
# install #
###########

install(
  DIRECTORY
    launch
  DESTINATION share/${PROJECT_NAME}
)


########
# test #
########

if(BUILD_TESTING)
  # Python unit tests
  find_package(ament_cmake_pytest REQUIRED)
  set(_pytest_tests
    test/test_unit.py
    # add other test pytest files here
  )
  foreach(_test_path ${_pytest_tests})
    get_filename_component(_test_name ${_test_path} NAME_WE)
    ament_add_pytest_test(${_test_name} ${_test_path}
      APPEND_ENV PYTHONPATH=${CMAKE_CURRENT_BINARY_DIR}
      TIMEOUT 20
      WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    )
  endforeach()

  # C++ unit tests
  find_package(ament_cmake_gtest REQUIRED)
  ament_add_gtest(test_unit_cpp test/test_unit.cpp)
  # add other unit test files here

  # Integration tests
  find_package(ament_cmake_ros REQUIRED)
  find_package(launch_testing_ament_cmake REQUIRED)
  function(add_ros_isolated_launch_test path)
    set(RUNNER "${ament_cmake_ros_DIR}/run_test_isolated.py")
    add_launch_test("${path}" RUNNER "${RUNNER}" ${ARGN})
  endfunction()
  add_ros_isolated_launch_test(test/test_integration.py)
  # add other integration test files here
endif()


# For reference: three other ways to trigger integration tests
if(FALSE)
  # 1: straight add_launch_test => no isolation (all same ROS_DOMAIN_ID)
  find_package(launch_testing_ament_cmake REQUIRED)
  add_launch_test(test/test_integration.py)

  # 2: wrap in pytest => whole file considered as one test
  #    (and also no more details in build/*.py.xunit.xml)
  find_package(ament_cmake_ros REQUIRED)
  ament_add_ros_isolated_pytest_test(
    dummyintegration test/test_integration.py)

  # 3: with setup.py instead of CMakeLists.txt => both disadvantages
  #    (though do get automatic test discovery)
endif()

ament_package()
