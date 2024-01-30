all: run

IMAGE = debian-cmake-gcc

build:
	docker build -t $(IMAGE) .

run: build
	docker run --rm -it $(IMAGE) bash

.PHONY: all build run
