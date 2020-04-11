#!/bin/bash
set -e

sudo dnf install \
    ninja-build \
    cups-devel \
    dbus-glib-devel \
    dbus-devel \
    systemd-devel \
    libuuid-devel \
    pulseaudio-libs-devel \
    gcc-c++ \
    libXrandr-devel \
    faac \
    faac-devel \
    faad2-devel \
    gsm-devel \
    gcc \
    cmake \
    openssl-devel \
    libX11-devel \
    libXext-devel \
    libXinerama-devel \
    libXcursor-devel \
    libXi-devel \
    libXdamage-devel \
    libXv-devel \
    libxkbfile-devel \
    alsa-lib-devel \
    cups-devel \
    ffmpeg-devel \
    glib2-devel \
    libjpeg-devel

mkdir -pv /tmp/freerdp-build
pushd /tmp/freerdp-build
git clone https://github.com/FreeRDP/FreeRDP.git
pushd FreeRDP
cmake \
    -DMONOLITHIC_BUILD=ON \
    -DBUILD_SHARED_LIBS=OFF \
    -DWITH_SSE2_TARGET=ON \
    -DWITH_CHANNELS=ON \
    -DBUILTIN_CHANNELS=ON \
    -DWITH_CUPS=OFF \
    -DWITH_WAYLAND=OFF \
    -DCHANNEL_URBDRC=OFF \
    -DCHANNEL_URBDRC_CLIENT=OFF \
    -DWITH_GSTREAMER=OFF \
    -DWITH_JPEG=ON \
    -DWITH_LIBSYSTEMD=OFF \
    -DWITH_XINERAMA=OFF \
    -DWITH_XEXT=ON \
    -DWITH_XCURSOR=OFF \
    .

sed -i 's/-Wall /-Wall -O3 /g' buildflags.h
sed -i '/client\/X11\/CMakeFiles\/xfreerdp.manpage.dir\/depend/ d' CMakeFiles/Makefile2
sed -i '/client\/X11\/CMakeFiles\/xfreerdp.manpage.dir\/build/ d' CMakeFiles/Makefile2
make -j $(($(nproc) + 2))

cp -fv client/X11/xfreerdp /tmp/freerdp-build/
cp -fv winpr/tools/makecert-cli/winpr-makecert /tmp/freerdp-build/
cp -fv winpr/tools/hash-cli/winpr-hash /tmp/freerdp-build/

echo "cleanup..."
popd
rm -rf FreeRDP
popd
echo "done"
ls -lh --color=always /tmp/freerdp-build
