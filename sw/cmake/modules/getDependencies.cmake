#
# Try to detect in the system several dependencies required. These are
# the dependencies we have:
#
# - Intel OPAE: required to control offloading to Intel HARP FPGAs.
# - Intel OPAE ASE + BBB_CCI_MPF: required to control Intel ASE.
# - boost program_options : required by OPAE
# - uuid
# - json-c

include (FindPackageHandleStandardArgs)
include (FindJSON-C)

################################################################################
# Looking for Intel OPAE ...
################################################################################
find_path (
    OPAE_INCLUDE_DIRS
  NAMES
    opae/fpga.h
  PATHS
    /usr/include
    /usr/local/include
    /opt/local/include
    /sw/include
    ${OPAE}/include
    ENV CPATH)

find_library (
  OPAE_OPAE_C_LIBRARY
  NAMES
    opae-c
  PATHS
    /usr/lib
    /usr/local/lib
    /opt/local/lib
    /sw/lib
    ${OPAE}/lib
    ENV LIBRARY_PATH
    ENV LD_LIBRARY_PATH)

set(OPAE_LIBRARIES
  ${OPAE_LIBRARIES}
  ${OPAE_OPAE_C_LIBRARY})

find_package_handle_standard_args(
  OPAE
  DEFAULT_MSG
  OPAE_LIBRARIES
  OPAE_INCLUDE_DIRS)

mark_as_advanced(
  OPAE_INCLUDE_DIRS
  OPAE_LIBRARIES)

################################################################################
# Looking for Intel OPAE ASE ...
################################################################################
find_path (
    OPAE_ASE_INCLUDE_DIRS
  NAMES
    opae/fpga.h
  PATHS
    /usr/include
    /usr/local/include
    /opt/local/include
    /sw/include
    ${OPAE}/include
    ENV CPATH)

find_library (
  OPAE_ASE_C_LIBRARY
  NAMES
    opae-c-ase
  PATHS
    /usr/lib
    /usr/local/lib
    /opt/local/lib
    /sw/lib
    ${OPAE}/lib
    ENV LIBRARY_PATH
    ENV LD_LIBRARY_PATH)

set(OPAE_ASE_LIBRARIES
  ${OPAE_ASE_LIBRARIES}
  ${OPAE_ASE_C_LIBRARY})

find_package_handle_standard_args(
  OPAE_ASE
  DEFAULT_MSG
  OPAE_ASE_LIBRARIES
  OPAE_ASE_INCLUDE_DIRS)

mark_as_advanced(
  OPAE_ASE_INCLUDE_DIRS
  OPAE_ASE_LIBRARIES)

################################################################################
# Looking for Intel BBB_CCI_MPF ...
################################################################################
find_path (
    BBB_CCI_MPF_INCLUDE_DIRS
  NAMES
    opae/mpf/mpf.h
  PATHS
    /usr/include
    /usr/local/include
    /opt/local/include
    /sw/include
    ${BBB_CCI_MPF}/include
    ENV CPATH)

find_library (
  BBB_CCI_MPF_MPF_LIBRARY
  NAMES
    MPF
  PATHS
    /usr/lib
    /usr/local/lib
    /opt/local/lib
    /sw/lib
    ${BBB_CCI_MPF}/lib
    ENV LIBRARY_PATH
    ENV LD_LIBRARY_PATH)

set(BBB_CCI_MPF_LIBRARIES
  ${BBB_CCI_MPF_LIBRARIES}
  ${BBB_CCI_MPF_MPF_LIBRARY})

find_package_handle_standard_args(
  BBB_CCI_MPF
  DEFAULT_MSG
  BBB_CCI_MPF_LIBRARIES
  BBB_CCI_MPF_INCLUDE_DIRS)

mark_as_advanced(
  BBB_CCI_MPF_INCLUDE_DIRS
  BBB_CCI_MPF_LIBRARIES)

################################################################################
# Looking for BOOST ...
################################################################################
find_package(Boost COMPONENTS program_options QUIET)

set(BOOST_FOUND ${Boost_FOUND})
set(BOOST_LIBRARIES ${Boost_LIBRARIES})
set(BOOST_INCLUDE_DIRS ${Boost_INCLUDE_DIRS})

mark_as_advanced(
  BOOST_FOUND
  BOOST_INCLUDE_DIRS
  BOOST_LIBRARIES)

################################################################################
# Looking for JSON-C ...
################################################################################
find_package(JSON-C QUIET)

set(JSON-C_FOUND ${JSON-C_FOUND})
set(JSON-C_LIBRARIES ${JSON-C_LIBRARIES})
set(JSON-C_INCLUDE_DIRS ${JSON-C_INCLUDE_DIRS})

mark_as_advanced(
  JSON-C_FOUND
  JSON-C_INCLUDE_DIRS
  JSON-C_LIBRARIES)

################################################################################
# Looking for UUID ...
################################################################################
find_package(UUID QUIET)

set(UUID_FOUND ${UUID_FOUND})
set(UUID_LIBRARIES ${UUID_LIBRARIES})
set(UUID_INCLUDE_DIRS ${UUID_INCLUDE_DIRS})

mark_as_advanced(
  UUID_FOUND
  UUID_INCLUDE_DIRS
  UUID_LIBRARIES)
