#
# Install libneurolabi from source
#

if (NOT libneurolabi_NAME)

  include(${BUILDEM_REPO_DIR}/neulib_com.cmake)

  SET(config_args --enable-shared --disable-fftw --disable-fftwf --disable-z --disable-xml --disable-jansson LIB_SUFFIX=_png) 
  SET(depends_args ${libpng_NAME})
  INSTALL_NEULIB(libneurolabi_png "${config_args}" "${depends_args}")

endif (NOT libneurolabi_NAME)
