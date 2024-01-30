FROM debian:12-slim

RUN apt-get update && apt-get install -y cmake g++ \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /root/

COPY CMakeLists.txt .
COPY main.cpp .
