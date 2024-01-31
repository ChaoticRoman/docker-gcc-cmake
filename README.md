# Docker image for experiments with CMake, g++ and dependency installation

## Manual

TODO

## System package manager

```
apt update
apt install libfmt-dev libmbedtls-dev

# hacking with cmake that does not work because Mbed TLS does not support find_package:
# https://github.com/Mbed-TLS/mbedtls/issues/7967
mkdir build
cd build
cmake ..  # WTF?

# This works though
g++ main.cpp -lfmt  # WTF?!
```

**Bonus:** https://askubuntu.com/a/449

## CPM

Adding CPM:
```
mkdir -p cmake
wget -O cmake/CPM.cmake https://github.com/cpm-cmake/CPM.cmake/releases/latest/download/get_cpm.cmake
```

Adding CPM support and packages to `CMakeLists.txt`:
```
include(cmake/CPM.cmake)

CPMAddPackage("gh:fmtlib/fmt@7.1.3")
CPMAddPackage("gh:Mbed-TLS/mbedtls@2.28.7")
```

Remove alias prefix `MbedTLS::` from the target.

```
mkdir build
cd build
cmake ..
make
```

Update to Mbed TLS 3.5.2 is effortless change in `CMakeLists.txt`.

## vcpkg

Get vcpkg:
```
git clone https://github.com/Microsoft/vcpkg.git
./vcpkg/bootstrap-vcpkg.sh
```
Install missing packages, rinse and repeat.

Get packages:
```
./vcpkg/vcpkg install fmt mbedtls
```
Install missing package, rinse and repeat.

Configure vcpkg for your application:
```
./vcpkg/vcpkg new --application
./vcpkg/vcpkg add port fmt mbedtls
```

Configure your project
```
cmake -B build -S . -DCMAKE_TOOLCHAIN_FILE=./vcpkg/scripts/buildsystems/vcpkg.cmake
```
Failure, remove `find_package` and alias for Mbed TLS. Install it with system package
manager:

```
apt install libmbedtls-dev
```

Don't expect any luck with 3.x:

https://github.com/microsoft/vcpkg/issues/25703

## Conan

Conan is Python 3 pip installable, so get required tools:

```
apt install pipx
pipx ensurepath
```

Install the conan, you would need also apply updated profile:

```
pipx install conan
source ~/.profile
```

Create our conan profile:

```
conan profile detect --force
```

Get us `conanfile.txt`:

```
[requires]
fmt/10.2.1
mbedtls/2.28.4

[generators]
CMakeDeps
CMakeToolchain
```

Install our dependencies and generate buildfiles:

```
conan install . --output-folder=build --build=missing
```

Configure and build our binary:

```
cd build
cmake .. -DCMAKE_TOOLCHAIN_FILE=conan_toolchain.cmake -DCMAKE_BUILD_TYPE=Release
cmake --build .
```

Run the result with `./hello`.

Try reinstalling with mbedtls bumped to 3.5.1.
