{
  description = "Azure IoT Hub C SDK - a C client library for connecting devices to Microsoft Azure IoT services";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "azure-iot-sdk-c";
          version = "LTS_03_2025";

          src = pkgs.fetchFromGitHub {
            owner = "Azure";
            repo = "azure-iot-sdk-c";
            rev = "LTS_03_2025";
            sha256 = "sha256-I7ObUQzgyHdick+24Oy0VHD2PxgCbE/UIUEn08cSJDM=";
            fetchSubmodules = true;
          };

          nativeBuildInputs = with pkgs; [
            cmake
            pkg-config
          ];

          buildInputs = with pkgs; [
            openssl
            curl
            util-linux
          ];

          cmakeFlags = [
            "-DCMAKE_INSTALL_PREFIX=$out"
            "-DCMAKE_C_STANDARD=11"
            "-Dskip_samples:BOOL=ON"
            "-Dbuild_as_dynamic:BOOL=ON"
            "-Duse_prov_client:BOOL=ON"
            "-Dhsm_type_x509:BOOL=ON"
            "-Duse_http:BOOL=OFF"
            "-Duse_amqp:BOOL=OFF"
            "-Duse_mqtt:BOOL=ON"
            "-Dbuild_service_client:BOOL=OFF"
            "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
          ];

          preConfigure = ''
            git submodule update --init || true
          '';

          postInstall = ''
            mkdir -p $out/lib/pkgconfig

            echo "prefix=$out" > $out/lib/pkgconfig/libiothub_client.pc
            cat >> $out/lib/pkgconfig/libiothub_client.pc <<'PCEOF'
libdir=''${prefix}/lib
includedir=''${prefix}/include
Name: libiothub_client
Description: AZURE IoT Hub Client libraries
Version: 1.3.8
Libs: -L''${libdir} -liothub_client -lserializer
Cflags: -I''${includedir}/azureiot
PCEOF

            echo "prefix=$out" > $out/lib/pkgconfig/libaziotsharedutil.pc
            cat >> $out/lib/pkgconfig/libaziotsharedutil.pc <<'PCEOF'
libdir=''${prefix}/lib
includedir=''${prefix}/include
Name: libaziotsharedutil
Description: Azure C Shared Utility
Version: 1.1.12
Libs: -L''${libdir} -laziotsharedutil
Cflags: -I''${includedir}/azureiot/azure_c_shared_utility
PCEOF

            echo "prefix=$out" > $out/lib/pkgconfig/libumqtt.pc
            cat >> $out/lib/pkgconfig/libumqtt.pc <<'PCEOF'
libdir=''${prefix}/lib
includedir=''${prefix}/include
Name: libumqtt
Description: Microsoft Azure MQTT
Version: 1.1.12
Libs: -L''${libdir} -lumqtt
Cflags: -I''${includedir}/azureiot/azure_umqtt_c
PCEOF

            echo "prefix=$out" > $out/lib/pkgconfig/libiothub_client_mqtt_ws_transport.pc
            cat >> $out/lib/pkgconfig/libiothub_client_mqtt_ws_transport.pc <<'PCEOF'
libdir=''${prefix}/lib
includedir=''${prefix}/include
Name: libiothub_client_mqtt_ws_transport
Description: Microsoft Azure MQTT WS transport
Version: 1.3.8
Libs: -L''${libdir} -liothub_client_mqtt_ws_transport -lprov_mqtt_ws_transport
Cflags: -I''${includedir}/azureiot/ -I''${includedir}/azure_prov_client/
PCEOF

            echo "prefix=$out" > $out/lib/pkgconfig/libprov_device_client.pc
            cat >> $out/lib/pkgconfig/libprov_device_client.pc <<'PCEOF'
libdir=''${prefix}/lib
includedir=''${prefix}/include
Name: libprov_device_client
Description: AZURE IoT Hub Client libraries
Version: 1.3.8
Libs: -L''${libdir} -lprov_device_client -lhsm_security_client
Cflags: -I''${includedir}/azure_prov_client
PCEOF

            mkdir -p $out/share/licenses/azure-iot-sdk-c
            cp $src/LICENSE $out/share/licenses/azure-iot-sdk-c/LICENSE
          '';

          meta = with pkgs.lib; {
            description = "Azure IoT Hub C SDK - a C client library for connecting devices to Microsoft Azure IoT services";
            homepage = "https://github.com/Azure/azure-iot-sdk-c";
            license = licenses.mit;
            platforms = platforms.unix;
          };
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            cmake
            pkg-config
            openssl
            curl
            git
          ];
        };
      }
    );
}
