# Mettre à jour les paquets de bases
apt update && apt full-upgrade -y

# Installer les paquets requis
#apt install git cmake g++ dh-autoreconf hwloc build-essential libpcap-dev libpcre3-dev bison flex libhwloc-dev zlib1g-dev
apt install build-essential autotools-dev libpcre3 libpcre3-dev libpcap-dev libdumbnet-dev bison flex zlib1g-dev liblzma-dev libssl-dev pkg-config hwloc libhwloc-dev cmake git
apt install libluajit-5.1-dev

# Paquet Libdaq
git clone https://github.com/snort3/libdaq.git
cd libdaq
./bootstrap
./configure
make
make install
cd

# Installer snort
git clone https://github.com/snort3/snort3.git
cd snort3
./configure_cmake.sh
cd build
cd

