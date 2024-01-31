FROM debian:12-slim

RUN apt-get update \
    && apt-get install -y nano git cmake g++ wget curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /root/hello/

COPY CMakeLists.txt .
COPY main.cpp .
