#
# Install thrift from source
#

if (NOT thrift_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

# We assume we want boost, C++, and python support
include (boost)
include (python)

set (thrift_EXE             ${BUILDEM_BIN_DIR}/thrift)
set (thrift_INCLUDE_DIR     ${BUILDEM_INCLUDE_DIR}/thrift)
set (thrift_CXX_FLAGS       "-DHAVE_NETINET_IN_H -DHAVE_INTTYPES_H")

include_directories (${thrift_INCLUDE_DIR})

external_source (thrift
    0.9.0
    thrift-0.9.0.tar.gz
    beb2c8290e97c93e3b2844f558cc5c7d
    https://dist.apache.org/repos/dist/release/thrift/0.9.0)

message ("Installing ${thrift_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${thrift_NAME}
    DEPENDS             ${boost_NAME} ${python_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${thrift_URL}
    URL_MD5             ${thrift_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ./configure 
        --prefix=${BUILDEM_DIR} 
        --with-boost=${BUILDEM_DIR}
        --with-openssl=${BUILDEM_DIR} 
        --with-haskell=no
        --with-java=no
        --with-php=no
        --with-perl=no
        --with-ruby=no
        PY_PREFIX=${PYTHON_PREFIX}
        "LDFLAGS=${BUILDEM_LDFLAGS} ${BUILDEM_ADDITIONAL_CXX_FLAGS}"
        "CPPFLAGS=-I${BUILDEM_DIR}/include ${BUILDEM_ADDITIONAL_CXX_FLAGS}"
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} $(MAKE)
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} $(MAKE) install
)

set (thrift_STATIC_LIBRARIES ${BUILDEM_LIB_DIR}/libthrift.a)
set (thrift_LIBRARIES ${BUILDEM_LIB_DIR}/libthrift.${BUILDEM_PLATFORM_DYLIB_EXTENSION})

set_target_properties(${thrift_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT thrift_NAME)