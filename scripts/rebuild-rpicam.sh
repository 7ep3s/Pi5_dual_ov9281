#https://forums.raspberrypi.com/viewtopic.php?t=359932
#first update kernel to latest
#may need to remove "auto_initramfs=1" from config.txt to avoid some odd effects.
#sudo rpi-update rpi-6.1.y

#after that:

#rebuild libcamera
sudo apt install -y python3-pip git python3-jinja2

sudo apt install -y libboost-dev
sudo apt install -y libgnutls28-dev openssl libtiff5-dev pybind11-dev
sudo apt install -y qtbase5-dev libqt5core5a libqt5gui5 libqt5widgets5
sudo apt install -y meson cmake
sudo apt install -y python3-yaml python3-ply

sudo apt install -y libglib2.0-dev libgstreamer-plugins-base1.0-dev

cd
git clone https://github.com/raspberrypi/libcamera.git
cd libcamera

meson setup build \
    --buildtype=release \
    -Dpipelines=rpi/vc4,rpi/pisp \
    -Dipas=rpi/vc4,rpi/pisp \
    -Dv4l2=true \
    -Dgstreamer=enabled \
    -Dtest=false \
    -Dlc-compliance=disabled \
    -Dcam=disabled \
    -Dqcam=disabled \
    -Ddocumentation=disabled \
    -Dpycamera=enabled

ninja -C build   # use -j 2 on Raspberry Pi 3 or earlier devices
sudo ninja -C build install


#rebuild  libepoxy
sudo apt install -y libegl1-mesa-dev

cd
git clone https://github.com/anholt/libepoxy.git
cd libepoxy
mkdir _build
cd _build
meson
ninja
sudo ninja install

#rebuild rpicam-apps
sudo apt install -y cmake libboost-program-options-dev libdrm-dev libexif-dev
sudo apt install -y meson ninja-build

cd
git clone https://github.com/raspberrypi/rpicam-apps.git
cd rpicam-apps

meson setup build \
    -Denable_libav=true \
    -Denable_drm=true \
    -Denable_egl=true \
    -Denable_qt=true \
    -Denable_opencv=false \
    -Denable_tflite=false

meson compile -C build # use -j1 on Raspberry Pi 3 or earlier devices
sudo meson install -C build
sudo ldconfig # this is only necessary on the first build