#!/bin/sh
set -x
if [ "$ANDROID_BUILD_TOP" == "" ]; then
    echo " need to lunch to get ANDROID_BUILD_TOP defined!"
    exit -1;
fi

if [ "$ANDROID_NDK_TOP" == "" ]; then
    echo  "need to set ANDROID_NDK_TOP as an environment variable so I know where your ndk is installed"
    exit -1;
fi

KLAATU_CXXFLAGS="-fno-exceptions -fno-rtti  -g -O0 \
-DKLAATU  \
-DUSE_ARM_NEON -DUSE_ARM_SIMD \
-march=armv7-a  -mfpu=neon -msoft-float -mthumb \
-include limits.h \
-I${ANDROID_NDK_TOP}/sources/cxx-stl/gnu-libstdc++/4.6/include \
-I${ANDROID_NDK_TOP}/sources/cxx-stl/gnu-libstdc++/4.6/libs/armeabi-v7a/include \
-I${ANDROID_BUILD_TOP}/usr/include/bionic \
-DANDROID \
--sysroot=${ANDROID_BUILD_TOP} \
"

KLAATU_LDFLAGS=" \
-Wl,--gc-sections -Wl,-z,nocopyreloc \
-Wl,--no-undefined -Wl,-z,noexecstack -Wl,-z,relro -Wl,-z,now \
--sysroot=${ANDROID_BUILD_TOP} \
-L${ANDROID_BUILD_TOP}/usr/local/lib \
-L${ANDROID_NDK_TOP}/sources/cxx-stl/gnu-libstdc++/4.6/libs/armeabi-v7a \
-g "
${ANDROID_NDK_TOP}/toolchains/arm-linux-androideabi-4.6/prebuilt/linux-x86/bin/arm-linux-androideabi-g++ $KLAATU_CXXFLAGS -o  tri.o -c tri.cpp 
${ANDROID_NDK_TOP}/toolchains/arm-linux-androideabi-4.6/prebuilt/linux-x86/bin/arm-linux-androideabi-g++ $KLAATU_LDFLAGS -o tri_klaatu tri.o -lc -lm -lEGL -lGLESv2 -lgui -llog -lbinder -lutils -lstdc++ 
