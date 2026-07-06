#!/usr/bin/env bash
set -euo pipefail

# 1. Clone and patch the main repository
git clone https://github.com/prophesee-ai/openeb.git
cd openeb
mkdir -p ./cmake/overlays/{ports,triplets}
git am < ../0001-add-vcpkg-installer.patch

# 2. Setup vcpkg and its tool source code standard layout
git clone https://github.com/microsoft/vcpkg.git vcpkg
cd vcpkg
git clone https://github.com/microsoft/vcpkg-tool.git toolsrc

# Set environmental flags
export VCPKG_ROOT="$(pwd)"
export VCPKG_DISABLE_METRICS="true"

# Compile vcpkg natively from the toolsrc folder layout
./bootstrap-vcpkg.sh -useSystemBinaries

# Return to the root of openeb
cd ..

# 3. Configure the main build system
cmake -B build \
    -DCMAKE_TOOLCHAIN_FILE="$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake" \
    -DVCPKG_TARGET_TRIPLET=x64-linux-release \
    -DVCPKG_OVERLAY_PORTS=cmake/overlays/ports \
    -DCMAKE_C_COMPILER=gcc \
    -DCMAKE_CXX_COMPILER=g++ \
    -DCMAKE_CXX_FLAGS="-include cstdint" \
    -DCMAKE_EXE_LINKER_FLAGS="-lstdc++ -ludev" \
    -DCMAKE_SHARED_LINKER_FLAGS="-lstdc++ -ludev" \
    -DCMAKE_INSTALL_SET_DESTDIR=ON \
    -DCMAKE_INSTALL_PREFIX="$(pwd)/dist"

# 4. Compile and output artifacts locally
cmake --build build -j "$(nproc)"
cmake --install build

mkdir -p dist/etc/udev/
cp hal_psee_plugins/resources/rules/*.rules dist/etc/udev
