FROM nvcr.io/nvidia/cuda:12.1.1-cudnn8-devel-ubuntu22.04

ARG TENSORRT_VERSION=8.6.1.6
ARG CUDA_USER_VERSION=12.0
ARG CUDNN_USER_VERSION=8.9
ARG OPERATING_SYSTEM=Linux

ENV DEBIAN_FRONTEND=noninteractive

# Install package dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        autoconf \
        automake \
        libtool \
        pkg-config \
        ca-certificates \
        wget \
        git \
        curl \
        libjpeg-dev \
        libpng-dev \
        language-pack-en \
        locales \
        locales-all \
        python3 \
        python3-dev \
        python3-pip \
        python3-setuptools \
        libprotobuf-dev \
        protobuf-compiler \
        zlib1g-dev \
        swig \
        vim \
        gdb \
        valgrind \
        libsm6 \
        libxext6 \
        libxrender-dev \
        cmake && \
    apt-get clean

RUN cd /usr/local/bin && \
    ln -s /usr/bin/python3 python && \
    ln -s /usr/bin/pip3 pip && \
    pip install --upgrade pip setuptools wheel

# System locale
# Important for UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

COPY ./downloads/TensorRT-${TENSORRT_VERSION}.${OPERATING_SYSTEM}.x86_64-gnu.cuda-${CUDA_USER_VERSION}.tar.gz /opt
RUN cd /opt && \
    tar -xzf TensorRT-${TENSORRT_VERSION}.${OPERATING_SYSTEM}.x86_64-gnu.cuda-${CUDA_USER_VERSION}.tar.gz && \
    rm TensorRT-${TENSORRT_VERSION}.${OPERATING_SYSTEM}.x86_64-gnu.cuda-${CUDA_USER_VERSION}.tar.gz && \
    export PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}' | cut -d. -f1,2 | tr -d .) && \
    python3 -m pip install TensorRT-${TENSORRT_VERSION}/python/tensorrt-*-cp${PYTHON_VERSION}-none-linux_x86_64.whl && \
    python3 -m pip install TensorRT-${TENSORRT_VERSION}/python/tensorrt_lean-*-cp${PYTHON_VERSION}-none-linux_x86_64.whl && \
    python3 -m pip install TensorRT-${TENSORRT_VERSION}/python/tensorrt_dispatch-*-cp${PYTHON_VERSION}-none-linux_x86_64.whl && \
    # Deprecated.
    # python3 -m pip install TensorRT-${TENSORRT_VERSION}/uff/uff-*-py2.py3-none-any.whl && \
    # python3 -m pip install TensorRT-${TENSORRT_VERSION}/graphsurgeon/graphsurgeon-*-py2.py3-none-any.whl && \
    python3 -m pip install TensorRT-${TENSORRT_VERSION}/onnx_graphsurgeon/onnx_graphsurgeon-*-py2.py3-none-any.whl

ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/TensorRT-${TENSORRT_VERSION}/lib
ENV PATH=$PATH:/opt/TensorRT-${TENSORRT_VERSION}/bin
