#!/bin/bash
# Cross compile ipsvd for mipsbe, armv5, ppc, mipsel, amd64

# Install toolchains
apt update && apt -y install git gcc-multilib-mipsel-linux-gnu gcc-multilib-powerpc-linux-gnu gcc-multilib-arm-linux-gnueabi gcc-multilib-mips-linux-gnu

# Get ipsvd source
git clone https://github.com/af001/ipsvd.git
cd ipsvd/net/ipsvd-1.0.0

# Alternate download
#wget http://smarden.org/ipsvd/ipsvd-1.0.0.tar.gz
#tar xzvf ipsvd-1.0.0.tar.gz
#cd ipsvd-1.0.0

# Modify src to include the -static flag
sed -i 's/"}/"} -static/g' src/print-ld.sh

# Compile for amd64
./package/compile

# Make binary directories in command
mkdir -p command/{mipsbe,mipsel,ppc,arm,amd64}

# Move built amd64 binaries
mv command/tcpsvd command/amd64
mv command/udpsvd command/amd64

# Modify build scripts for cross-compiling
cd compile/
sed -i 's/cc=/#cc=/g' print-cc.sh
sed -i '2s/^/cc=$CC\n/' print-cc.sh
sed -i 's/ld=/#ld=/g' print-ld.sh
sed -i '2s/^/ld=$CC -s\n/' print-ld.sh
cp -av print-ar.sh /tmp

# Compile ARM
make clean
sed -i 's/ranlib/arm-linux-gnueabi-ranlib/g' print-ar.sh
CC='arm-linux-gnueabi-gcc' make tcpavd udpavd
CC='arm-linux-gnueabi-gcc' gcc -O2 -Wall chkshsgr.c -o chkshsgr
CC='arm-linux-gnueabi-gcc' make tcpavd udpavd
mv tcpavd udpavd ../command/arm

# Compile MIPSBE
make clean
sed -i 's/ranlib/mips-linux-gnu-ranlib/g' print-ar.sh
CC='mips-linux-gnu-gcc' make tcpavd udpavd
CC='mips-linux-gnu-gcc' gcc -O2 -Wall chkshsgr.c -o chkshsgr
CC='mips-linux-gnu-gcc' make tcpavd udpavd
mv tcpavd udpavd ../command/mipsbe

# Compile MIPSEL
make clean
sed -i 's/ranlib/mipsel-linux-gnu-ranlib/g' print-ar.sh
CC='mipsel-linux-gnu-gcc' make tcpavd udpavd
CC='mipsel-linux-gnu-gcc' gcc -O2 -Wall chkshsgr.c -o chkshsgr
CC='mipsel-linux-gnu-gcc' make tcpavd udpavd
mv tcpavd udpavd ../command/mipsel

# Compile PowerPc
make clean
sed -i 's/ranlib/powerpc-linux-gnu-ranlib/g' print-ar.sh
CC='powerpc-linux-gnu-gcc' make tcpavd udpavd
CC='powerpc-linux-gnu-gcc' gcc -O2 -Wall chkshsgr.c -o chkshsgr
CC='powerpc-linux-gnu-gcc' make tcpavd udpavd
mv tcpavd udpavd ../command/ppc

# Reference and writeup: https://www.programmersought.com/article/15776489772/

