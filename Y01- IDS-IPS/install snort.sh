# Mettre à jour les paquets de bases
apt update && apt full-upgrade -y

# Installer les paquets requis
apt install git cmake g++ dh-autoreconf build-essential libpcap-dev libpcre3-dev bison flex

# Libdnet
git clone https://github.com/ofalk/libdnet.git
# Libdaq
git clone https://github.com/snort3/libdaq.git
cd /libdaq
autoupdate
./bootstrap
./configure
make
make install

# Installer snort

# Faire un clone du dépot github snort
git clone https://github.com/snort3/snort3.git

# Lancer la config de snort
cd snort

export my_path=/path/to/snorty
./configure_cmake.sh --prefix=$my_path
cd build
./configure 