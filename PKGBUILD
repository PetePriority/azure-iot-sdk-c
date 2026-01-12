# Maintainer: Your Name <your.email@example.com>
pkgname=azure-iot-sdk-c
pkgver=LTS_03_2025
pkgrel=1
pkgdesc="Azure IoT Hub C SDK - a C client library for connecting devices to Microsoft Azure IoT services"
arch=('x86_64' 'aarch64' 'armv7h')
url="https://github.com/Azure/azure-iot-sdk-c"
license=('MIT')
depends=('openssl' 'curl')
makedepends=('git' 'cmake')
source=("git+https://github.com/Azure/azure-iot-sdk-c.git#tag=LTS_03_2025")
sha256sums=('SKIP')
options=(!strip !debug)

prepare() {
    cd "$srcdir/$pkgname"
    git submodule update --init
}

build() {
    cmake -B cmake -S "$srcdir/$pkgname" \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DCMAKE_C_STANDARD=11 \
        -Dskip_samples:BOOL=ON \
        -Dbuild_as_dynamic:BOOL=ON \
        -Duse_prov_client:BOOL=ON \
        -Dhsm_type_x509:BOOL=ON \
        -Duse_http:BOOL=OFF \
        -Duse_amqp:BOOL=OFF \
        -Duse_mqtt:BOOL=ON \
        -Dbuild_service_client:BOOL=OFF \
        -DCMAKE_POLICY_VERSION_MINIMUM=3.5

    cmake --build cmake
}

package() {
    DESTDIR="$pkgdir" cmake --build cmake --target install

    # Install pkg-config files
    install -Dm644 /dev/stdin "$pkgdir/usr/lib/pkgconfig/libiothub_client.pc" <<EOF
prefix=/usr
libdir=\${prefix}/lib
includedir=\${prefix}/include
Name: libiothub_client
Description: AZURE IoT Hub Client libraries
Version: 1.3.8
Libs: -L\${libdir} -liothub_client -lserializer
Cflags: -I\${includedir}/azureiot
EOF

    install -Dm644 /dev/stdin "$pkgdir/usr/lib/pkgconfig/libaziotsharedutil.pc" <<EOF
prefix=/usr
libdir=\${prefix}/lib
includedir=\${prefix}/include
Name: libaziotsharedutil
Description: Azure C Shared Utility
Version: 1.1.12
Libs: -L\${libdir} -laziotsharedutil
Cflags: -I\${includedir}/azureiot/azure_c_shared_utility
EOF

    install -Dm644 /dev/stdin "$pkgdir/usr/lib/pkgconfig/libumqtt.pc" <<EOF
prefix=/usr
libdir=\${prefix}/lib
includedir=\${prefix}/include
Name: libumqtt
Description: Microsoft Azure MQTT
Version: 1.1.12
Libs: -L\${libdir} -lumqtt
Cflags: -I\${includedir}/azureiot/azure_umqtt_c
EOF

    install -Dm644 /dev/stdin "$pkgdir/usr/lib/pkgconfig/libiothub_client_mqtt_ws_transport.pc" <<EOF
prefix=/usr
libdir=\${prefix}/lib
includedir=\${prefix}/include
Name: libiothub_client_mqtt_ws_transport
Description: Microsoft Azure MQTT WS transport
Version: 1.3.8
Libs: -L\${libdir} -liothub_client_mqtt_ws_transport -lprov_mqtt_ws_transport
Cflags: -I\${includedir}/azureiot/ -I\${includedir}/azure_prov_client/
EOF

    install -Dm644 /dev/stdin "$pkgdir/usr/lib/pkgconfig/libprov_device_client.pc" <<EOF
prefix=/usr
libdir=\${prefix}/lib
includedir=\${prefix}/include
Name: libprov_device_client
Description: AZURE IoT Hub Client libraries
Version: 1.3.8
Libs: -L\${libdir} -lprov_device_client -lhsm_security_client
Cflags: -I\${includedir}/azure_prov_client
EOF

    # Install license
    install -Dm644 "$srcdir/$pkgname/LICENSE" "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
}
