# Pull base image.
FROM toppersjp/armgcc-ubuntu:7-2018-q2

# Install
ENV PACKAGES libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1 \
 sudo vim libusb-1.0 curl  file  \
 build-essential gcc g++ libgtest-dev google-mock \
 openssl libssl-dev \
 make fish wget git libboost-all-dev openssh-server libboost-regex1.58.0 libboost-regex1.58-dev lib32stdc++6 lib32ncurses5 \
 pkg-config libglib2.0-dev libmount-dev python3 python3-pip python3-dev libffi-dev autoconf automake libfreetype6-dev \
 libtheora-dev libtool libvorbis-dev pkg-config texinfo zlib1g-dev unzip cmake yasm libx264-dev libmp3lame-dev libopus-dev \
 libvorbis-dev libxcb1-dev libxcb-shm0-dev libxcb-xfixes0-dev texinfo zlib1g-dev libpixman-1-dev \
 re2c \
 ruby  gcc-arm-none-eabi gdb-multiarch libpixman-1-0 libjpeg-dev 


# 32bitバイナリ対応
RUN dpkg --add-architecture i386 && \
 apt update && DEBIAN_FRONTEND=noninteractive  \
 apt install -y  $PACKAGES

#Homebrew
#$ sudo apt-get update && sudo apt-get -y install build-essential curl file git

RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && \
    echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >> /root/.profile && \
    eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv) 

#Ninja
RUN git clone git://github.com/ninja-build/ninja.git && cd ninja && \
./configure.py --bootstrap && cp ninja /usr/bin/

#TOOPERS ASP3
#sudo apt install ruby  gcc-arm-none-eabi gdb-multiarch libpixman-1-0 libjpeg-dev 
#以下はすでにある
#RUN wget https://github.com/toppers/qemu_zynq/releases/download/v2.12.0-toppers/qemu-system-arm.zip && \
#unzip qemu-system-arm.zip && \
#chmod +x qemu-system-arm

# ST-LINKのインストール　これは入れたい
#RUN apt install -y libusb-1.0
WORKDIR /home/cmake
RUN wget https://github.com/Kitware/CMake/releases/download/v3.17.1/cmake-3.17.1.tar.gz && \
 tar zxvf cmake-3.17.1.tar.gz && \
 cd cmake-3.17.1/ && \
 ./bootstrap && \
 make && make install

RUN git clone https://github.com/texane/stlink && cd stlink && make && \
    cd build/Release && make install && ldconfig && \
    rm -rf /home/cmake

WORKDIR /home

ENV PATH $PATH:/home/linuxbrew/.linuxbrew/bin

# 起動シェルbash
CMD ["/bin/bash"]
