# Initialize FlyEM build variables
# 
# Sets the following variables:
#
#   BUILDEM_BIN_DIR         Binary directory (/bin) for BPD
#   BUILDEM_LIB_DIR         Library directory (/lib) for BPD
#   BUILDEM_SRC_DIR         Source directory (/src) for BPD
#   BUILDEM_INCLUDE_DIR     Include directory (/include) for BPD
#
#   BUILDEM_BIN_PATH        Command path string suitable for PATH env variable.
#   BUILDEM_LIB_PATH        Library path string suitable for LD_LIBRARY_PATH env variable.
#   BUILDEM_ENV_STRING      Environment variable setting string for use before commands.

if (NOT BUILDEM_ENV_STRING)


if (NOT BUILDEM_DIR)
    message (FATAL_ERROR "ERROR: BuildEM build directory (for all downloads & builds) should be specified via -DBUILDEM_DIR=<path> on cmake command line.")
endif ()

if (NOT BUILDEM_REPO_DIR)
    message (FATAL_ERROR "ERROR: BUILDEM_REPO_DIR must be specified via your application's CMakeLists.txt file, and must be set to ${BUILDEM_DIR}/src/buildem.")
endif ()

# Make sure the main directories for FlyEM build directory are already 
# created so paths won't error out.
set (BUILDEM_BIN_DIR    ${BUILDEM_DIR}/bin)
if (NOT EXISTS ${BUILDEM_BIN_DIR})
    file (MAKE_DIRECTORY ${BUILDEM_BIN_DIR})
endif ()

set (BUILDEM_TEST_DIR    ${BUILDEM_DIR}/bin/tests)
if (NOT EXISTS ${BUILDEM_TEST_DIR})
    file (MAKE_DIRECTORY ${BUILDEM_TEST_DIR})
endif ()

set (BUILDEM_LIB_DIR    ${BUILDEM_DIR}/lib)
if (NOT EXISTS ${BUILDEM_LIB_DIR})
    file (MAKE_DIRECTORY ${BUILDEM_LIB_DIR})
endif ()

set (BUILDEM_INCLUDE_DIR    ${BUILDEM_DIR}/include)
if (NOT EXISTS ${BUILDEM_INCLUDE_DIR})
    file (MAKE_DIRECTORY ${BUILDEM_INCLUDE_DIR})
endif ()

set (BUILDEM_SRC_DIR    ${BUILDEM_DIR}/src)
if (NOT EXISTS ${BUILDEM_SRC_DIR})
    file (MAKE_DIRECTORY ${BUILDEM_SRC_DIR})
endif ()

if((${CMAKE_SYSTEM_NAME} MATCHES "Darwin") AND ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang"))
	if (NOT EXISTS /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.9.sdk)
		message (FATAL_ERROR "ERROR: XCode and the OSX 10.9 SDK have to be installed. Please install XCode from the AppStore")
	endif ()
	# set this additional parameter to link against the proper libstdc++
	set(BUILDEM_ADDITIONAL_CXX_FLAGS "-stdlib=libstdc++")
endif()

if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    # Important to use FALLBACK variable.
    # https://developer.apple.com/library/mac/#documentation/DeveloperTools/Conceptual/DynamicLibraries/100-Articles/DynamicLibraryUsageGuidelines.html
    set (BUILDEM_LD_LIBRARY_VAR "DYLD_FALLBACK_LIBRARY_PATH")
    set (BUILDEM_PLATFORM_SPECIFIC_ENV "MACOSX_DEPLOYMENT_TARGET=10.9")
    set (BUILDEM_PLATFORM_DYLIB_EXTENSION "dylib")
else()
    set (BUILDEM_LD_LIBRARY_VAR "LD_LIBRARY_PATH")
    set (BUILDEM_PLATFORM_SPECIFIC_ENV "")
    set (BUILDEM_PLATFORM_DYLIB_EXTENSION "so")
endif()

# Initialize environment variables string to use for commands.
set (BUILDEM_BIN_PATH     ${BUILDEM_BIN_DIR}:$ENV{PATH})
set (BUILDEM_LIB_PATH     ${BUILDEM_LIB_DIR}:$ENV{${BUILDEM_LD_LIBRARY_VAR}})
set (BUILDEM_ENV_STRING   env PATH=${BUILDEM_BIN_PATH} ${BUILDEM_LD_LIBRARY_VAR}=${BUILDEM_LIB_PATH} ${BUILDEM_PLATFORM_SPECIFIC_ENV} CC=${CMAKE_C_COMPILER} CXX=${CMAKE_CXX_COMPILER})
set (BUILDEM_LDFLAGS      "-Wl,-rpath,${BUILDEM_LIB_DIR} -L${BUILDEM_LIB_DIR}")

# All library builds should go to BPD/lib
set (CMAKE_ARCHIVE_OUTPUT_DIRECTORY  ${BUILDEM_LIB_DIR})
set (CMAKE_LIBRARY_OUTPUT_DIRECTORY  ${BUILDEM_LIB_DIR})
set (CMAKE_RUNTIME_OUTPUT_DIRECTORY  ${BUILDEM_BIN_DIR})

# Set standard include directories.
include_directories (BEFORE ${BUILDEM_INCLUDE_DIR})


endif (NOT BUILDEM_ENV_STRING)

