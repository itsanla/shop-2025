#!/bin/bash

cd apps/mobile

echo "Building optimized APK buk..."
echo ""

# ini untuk build split APK per ABI biar lebih kecil buk
flutter clean
flutter pub get
flutter build apk --release --split-per-abi

echo ""
if [ -f "build/app/outputs/flutter-apk/app-arm64-v8a-release.apk" ]; then
    echo "APK berhasil dibuat buk!"
    echo ""
    echo "Lokasi APK:"
    echo "- ARM 64-bit (paling umum): apps/mobile/build/app/outputs/flutter-apk/app-arm64-v8a-release.apk"
    echo "- ARM 32-bit: apps/mobile/build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk"
    echo "- x86 64-bit: apps/mobile/build/app/outputs/flutter-apk/app-x86_64-release.apk"
    echo ""
    echo "Ukuran APK:"
    ls -lh build/app/outputs/flutter-apk/*.apk | awk '{print $9, "-", $5}'
    echo ""
    echo "Upload yang ARM 64-bit ke GitHub Release buk (paling banyak dipakai)"
else
    echo "Build gagal buk!"
    exit 1
fi
