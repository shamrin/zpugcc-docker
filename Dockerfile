from shamrin/ubuntu32

env PATH /root/install/bin:$PATH

run apt-get -y install curl bzip2 make cmake
run cd root \
    && curl -O http://opensource.zylin.com/zpu/zpugcclinux.tar.bz2 \
    && tar jxf zpugcclinux.tar.bz2

run zpu-elf-gcc --version
