FROM python:3.6-slim

# poppler-utils install
RUN apt-get update && apt-get install -y
RUN apt-get install poppler-utils -y

# Python packages
RUN pip install numpy
RUN pip install opencv-python==3.4.5.20
RUN pip install pdf2image
RUN pip list

RUN rm -rf /var/cache/apt/*
