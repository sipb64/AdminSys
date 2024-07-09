# Mettre à jour les paquets de bases
apt update && apt full-upgrade -y

# Installer les paquets requis
apt install build-essential autotools-dev libpcre3 libpcre3-dev libpcap-dev libdumbnet-dev bison flex zlib1g-dev liblzma-dev libssl-dev pkg-config hwloc libhwloc-dev cmake git libluajit-5.1-dev

# Paquet Libdaq
git clone https://github.com/snort3/libdaq.git
cd libdaq
./bootstrap
./configure 
make install
ldconfig
cd

# Installer snort
git clone https://github.com/snort3/snort3.git
cd snort3
./configure_cmake.sh  
cd build
make -j $(nproc)
make install

alias snort='/root/snort3/build/src/snort'

snort -V