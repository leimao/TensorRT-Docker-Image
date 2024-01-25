# TensorRT Docker Image

## Introduction

This is a portable TensorRT Docker image which allows the user to profile executables anywhere using the TensorRT SDK inside the Docker container.

## Usages

### Download TensorRT SDK

To download the TensorRT SDK, please go to the [TensorRT website](https://developer.nvidia.com/tensorrt-download), login with NVIDIA Developer account if necessary, and download the TAR install packages for Linux into the `downloads` directory.

For example, the TAR install packages for TensorRT 8.6.1.6 looks like the following.

```bash
$ ls downloads/
TensorRT-8.6.1.6.Linux.x86_64-gnu.cuda-12.0.tar.gz
```

### Build Docker Image

To build the Docker image, please run the following command.

```bash
$ TENSORRT_VERSION=8.6.1.6
$ CUDA_USER_VERSION=12.0
$ docker build -f tensorrt.Dockerfile --no-cache --build-arg TENSORRT_VERSION=$TENSORRT_VERSION --build-arg CUDA_USER_VERSION=$CUDA_USER_VERSION --tag=tensorrt:$TENSORRT_VERSION .
```

### Run Docker Container

To run the Docker container, please run the following command.

```bash
$ docker run -it --rm --gpus all -v $(pwd):/mnt tensorrt:$TENSORRT_VERSION
```

### Run TRTEXEC

To verify the TensorRT installation, please build a TensorRT engine from an ONNX model using `trtexec` using the following command.

```bash
$ wget -P /tmp/ https://github.com/onnx/models/raw/ddbbd1274c8387e3745778705810c340dea3d8c7/validated/vision/classification/mnist/model/mnist-12.onnx
$ trtexec --onnx=/tmp/mnist-12.onnx
```

If the TensorRT installation is correct, the output should look like the following.

```bash
[01/24/2024-20:02:59] [I] === Performance summary ===
[01/24/2024-20:02:59] [I] Throughput: 40624.2 qps
[01/24/2024-20:02:59] [I] Latency: min = 0.020874 ms, max = 0.354187 ms, mean = 0.0249536 ms, median = 0.0246582 ms, percentile(90%) = 0.0258789 ms, percentile(95%) = 0.0263672 ms, percentile(99%) = 0.0344238 ms
[01/24/2024-20:02:59] [I] Enqueue Time: min = 0.0117188 ms, max = 0.0712891 ms, mean = 0.0130411 ms, median = 0.0126343 ms, percentile(90%) = 0.0130005 ms, percentile(95%) = 0.0134277 ms, percentile(99%) = 0.0257568 ms
[01/24/2024-20:02:59] [I] H2D Latency: min = 0.00195312 ms, max = 0.244873 ms, mean = 0.00396986 ms, median = 0.00390625 ms, percentile(90%) = 0.0045166 ms, percentile(95%) = 0.00463867 ms, percentile(99%) = 0.00488281 ms
[01/24/2024-20:02:59] [I] GPU Compute Time: min = 0.0151367 ms, max = 0.348145 ms, mean = 0.0171428 ms, median = 0.0166016 ms, percentile(90%) = 0.0174561 ms, percentile(95%) = 0.0183105 ms, percentile(99%) = 0.0256348 ms
[01/24/2024-20:02:59] [I] D2H Latency: min = 0.00219727 ms, max = 0.0393066 ms, mean = 0.0038367 ms, median = 0.00402832 ms, percentile(90%) = 0.00439453 ms, percentile(95%) = 0.0045166 ms, percentile(99%) = 0.00476074 ms
[01/24/2024-20:02:59] [I] Total Host Walltime: 3.00006 s
[01/24/2024-20:02:59] [I] Total GPU Compute Time: 2.08927 s
[01/24/2024-20:02:59] [W] * GPU compute time is unstable, with coefficient of variance = 29.0605%.
[01/24/2024-20:02:59] [W]   If not already in use, locking GPU clock frequency or adding --useSpinWait may improve the stability.
[01/24/2024-20:02:59] [I] Explanations of the performance metrics are printed in the verbose logs.
[01/24/2024-20:02:59] [I]
&&&& PASSED TensorRT.trtexec [TensorRT v8601] # trtexec --onnx=/tmp/mnist-12.onnx
```

## References

- [TensorRT In Docker](https://leimao.github.io/blog/Docker-TensorRT/)
