FROM python:3.6-slim

# poppler-utils install
RUN apt install poppler-utils

# Python packages
RUN pip install numpy
RUN pip install opencv-python<4.0
RUN pip list

RUN rm -rf /var/cache/apt/*
