cmake_minimum_required(VERSION 2.8 FATAL_ERROR)

project(pcd_write)

find_package(PCL 1.2 REQUIRED)
set(CMAKE_BUILD_TYPE Release)

include_directories(${PCL_INCLUDE_DIRS})
link_directories(${PCL_LIBRARY_DIRS})
add_definitions(${PCL_DEFINITIONS})

add_executable (visualizer visualizer.cpp)
target_link_libraries (visualizer ${PCL_LIBRARIES})
