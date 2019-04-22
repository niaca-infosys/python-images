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
RUN pip install opencv-python==3.4.5.20

# Purge cache
RUN rm -rf /var/cache/apk/*
