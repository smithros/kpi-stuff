cmake_minimum_required(VERSION 2.8)
project(ak_lab4)

add_library(operations STATIC sum.cpp multiply.cpp)
add_executable(out main.cpp)

target_link_libraries(out operations)
