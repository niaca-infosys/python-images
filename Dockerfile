FROM python:3.6-slim

# poppler-utils install
RUN apt-get update && apt-get install -y
RUN apt-get install -y poppler-utils libglib2.0 libsm6 libxext6 

# swig install
RUN apt-get install -y gcc-6 g++ libpcre3 libpcre3-dev wget
RUN mkdir /install && cd /install && wget http://prdownloads.sourceforge.net/swig/swig-3.0.12.tar.gz && tar -xzvf swig-3.0.12.tar.gz
RUN mkdir -p /sw/swigtool && cd /install/swig-3.0.12 && ./configure --prefix=/sw/swigtool && make && make install
RUN export SWIG_PATH=/sw/swigtool/bin && export PATH=$SWIG_PATH:$PATH


# Python packages
RUN pip install numpy
RUN pip install opencv-python==3.4.5.20
RUN pip install pdf2image
RUN pip install jamspell
RUN pip list

RUN rm -rf /var/cache/apt/*
