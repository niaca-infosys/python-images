FROM python:3.6-alpine

ENV CC=/usr/bin/clang \
    CXX=/usr/bin/clang++ \
    OPENCV_VERSION=3.4.6

RUN echo 'http://dl-cdn.alpinelinux.org/alpine/latest-stable/main' >> /etc/apk/repositories
RUN echo 'http://dl-cdn.alpinelinux.org/alpine/latest-stable/community' >> /etc/apk/repositories

#RUN echo -e '@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing\n\
#http://dl-cdn.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories

#Intel® TBB, a widely used C++ template library for task parallelism'
#RUN apk add -U libtbb@testing libtbb-dev@testing

# poppler-utils install
RUN apk add -U poppler-utils

# Wrapper for libjpeg-turbo
RUN apk add -U libjpeg openblas jasper
RUN apk add -U --virtual .build-dependencies build-base openblas-dev unzip wget cmake

# accelerated baseline JPEG compression and decompression library and other code libraries
RUN apk add libjpeg-turbo-dev libpng-dev jasper-dev tiff-dev libwebp-dev clang-dev linux-headers

# Python packages
RUN pip install numpy

# OpenCV installation
RUN mkdir -p /opt \
    && cd /opt \
    && wget --quiet https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip \
    && unzip -q ${OPENCV_VERSION}.zip \
    && rm -rf ${OPENCV_VERSION}.zip \
    && mkdir -p /opt/opencv-${OPENCV_VERSION}/build \
    && cd /opt/opencv-${OPENCV_VERSION}/build 

RUN cmake \
      -D CMAKE_BUILD_TYPE=RELEASE \
      -D CMAKE_INSTALL_PREFIX=/usr/local \
      -D WITH_FFMPEG=NO \
      -D WITH_IPP=NO \
      -D WITH_OPENEXR=NO \
      -D WITH_TBB=YES \
      -D BUILD_EXAMPLES=NO \
      -D BUILD_ANDROID_EXAMPLES=NO \
      -D INSTALL_PYTHON_EXAMPLES=NO \
      -D BUILD_DOCS=NO \
      -D BUILD_opencv_python2=NO \
      -D BUILD_opencv_python3=ON \
      -D PYTHON3_EXECUTABLE=/usr/local/bin/python \
      -D PYTHON3_INCLUDE_DIR=/usr/local/include/python3.6m/ \
      -D PYTHON3_LIBRARY=/usr/local/lib/libpython3.so \
      -D PYTHON_LIBRARY=/usr/local/lib/libpython3.so \
      -D PYTHON3_PACKAGES_PATH=/usr/local/lib/python3.6/site-packages/ \
      -D PYTHON3_NUMPY_INCLUDE_DIRS=/usr/local/lib/python3.6/site-packages/numpy/core/include/ \
      .. \
    && make VERBOSE=1 \
    && make \
    && make install \
    && rm -rf /opt/opencv-${OPENCV_VERSION} \
    && apk del .build-dependencies \
    && rm -rf /var/cache/apk/*
