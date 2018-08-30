cmake_minimum_required (VERSION 3.5)

project (template)

set(PROJECT_NAME template)
set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules ${CMAKE_MODULE_PATH})
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -O3")

include(getDependencies)

if(OPAE_ASE_FOUND)
if(BBB_CCI_MPF_FOUND)
if(UUID_FOUND)
if(BOOST_FOUND)
  message("Building ${PROJECT_NAME}")

  include_directories(${OPAE_ASE_INCLUDE_DIRS})
  include_directories(${BBB_CCI_MPF_INCLUDE_DIRS})
  include_directories(${UUID_INCLUDE_DIRS})
  include_directories(${BOOST_INCLUDE_DIRS})
  include_directories(${CMAKE_MODULE_PATH}/src)

  file(GLOB SOURCES "src/*.cpp")

  add_executable(${PROJECT_NAME} ${SOURCES})

  target_link_libraries(${PROJECT_NAME}
    ${OPAE_ASE_LIBRARIES}
    ${BBB_CCI_MPF_LIBRARIES}
    ${UUID_LIBRARIES}
    ${BOOST_LIBRARIES})

else(BOOST_FOUND)
  message(SEND_ERROR "Not building ${PROJECT_NAME}: boost program-options dependency not found.")
endif(BOOST_FOUND)
else(UUID_FOUND)
  message(SEND_ERROR "Not building ${PROJECT_NAME}: uuid dependency not found.")
endif(UUID_FOUND)
else(BBB_CCI_MPF_FOUND)
  message(SEND_ERROR "Not building ${PROJECT_NAME}: intel bbb_cci_mpf dependency not found.")
endif(BBB_CCI_MPF_FOUND)
else(OPAE_ASE_FOUND)
  message(SEND_ERROR "Not building ${PROJECT_NAME}: intel opae ase dependency not found.")
endif(OPAE_ASE_FOUND)

