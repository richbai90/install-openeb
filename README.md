# Install OpenEB

This repository provides an automated build and installation script for [Prophesee's OpenEB](https://github.com/prophesee-ai/openeb) (Open Event-Based) software. 

Instead of relying solely on system package managers, this script uses Microsoft's **vcpkg** package manager to fetch, patch, and build OpenEB's dependencies (such as OpenCV, Boost, HDF5, Protobuf, etc.) into an isolated environment. This ensures reproducible builds and avoids dependency conflicts on your host system.

## Features

- **Automated Process:** A single script handles cloning, patching, dependency resolution, configuring, and building.
- **Isolated Dependencies:** Uses `vcpkg` to manage strict versions for dependencies like `opencv`, `boost`, and `libusb`, without polluting your system directories.
- **Custom Overlays:** Includes specific `vcpkg` patches for custom ports (`gtk3`, `libsystemd`, `libusb`, `szip`) and a customized `x64-linux-release` triplet to work around common build issues.
- **Local Installation:** Artifacts are securely installed to a local `dist` folder rather than requiring `sudo` to install globally.

## Prerequisites

You will need a Linux environment with standard development tools installed:
- `git`
- `bash`
- `cmake`
- `gcc` / `g++` (C/C++ compilers)
- `pkg-config`
- Standard system utilities (like `nproc`, `make`)

## Usage

Simply run the installation script from the root of this repository:

```bash
./install-openeb.sh
```

### What the script does:

1. **Clone & Patch OpenEB:** Clones the main `prophesee-ai/openeb` repository and applies the `0001-add-vcpkg-installer.patch` to introduce `vcpkg` support.
2. **Setup vcpkg:** Clones `vcpkg` and its toolchain into the OpenEB directory, and bootstraps it locally using system binaries.
3. **Configure the Build:** Runs CMake using the `vcpkg` toolchain file and custom overlays, resolving dependencies directly from `vcpkg`.
4. **Compile & Install:** Builds OpenEB using all available CPU cores and outputs the compiled artifacts locally.

## Output

Once the build successfully finishes, you will find the compiled OpenEB binaries, libraries, and headers in the `openeb/dist` directory:

```bash
cd openeb/dist
```

From here, you can link the libraries to your own projects or run the OpenEB executables.
