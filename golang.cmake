#
# Install golang from source
#

if (NOT golang_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

external_source (golang
    1.3
    go1.3.src.tar.gz
    4b66d7249554181c314f139ea78920b1
    http://golang.org/dl)

message ("Installing ${golang_NAME} into build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${golang_NAME}
    PREFIX            ${BUILDEM_DIR}
    URL               ${golang_URL}
    URL_MD5           ${golang_MD5}
    UPDATE_COMMAND    ""
    PATCH_COMMAND     ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND     ""
    INSTALL_COMMAND   ""
)

# Impressively, we cannot get CMake to cd into a subdirectory of the source directory
# to issue the all.bash command.  To build, we must be in the src subdirectory.
# The only way we can get this to work is to add a step and explicitly have a 
# working directory.
ExternalProject_Add_Step(${golang_NAME} stupid_step
    COMMAND     ${BUILDEM_ENV_STRING} GOBIN=${BUILDEM_BIN_DIR} ./all.bash
    DEPENDEES  patch
    WORKING_DIRECTORY   ${golang_SRC_DIR}/src)

set (GO_ENV  GOROOT=${golang_SRC_DIR};GOBIN=${BUILDEM_BIN_DIR})

set_target_properties(${golang_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT golang_NAME)
