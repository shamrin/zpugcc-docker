## zpugcc-docker - ZPU GCC toolchain in a Docker container

`zpugcc-docker` is a Docker container for [ZPU GCC toolchain][1].

Why? Because ZPU GCC binary runs on 32-bit Linux only (and on Cygwin…), and compiling it from source isn't easy. On the other hand, this container runs wherever Docker runs.

[1]: http://opensource.zylin.com/zpudownload.html

### Usage

Create `Dockerfile` at the root of your project (that you want to compile with ZPU toolchain). Reference `shamrin/zpugcc` container, add directories you want toolchain to access, and run commands you need for the build (`make`, `cmake`, `zpu-elf-gcc` and others are available). Example `Dockerfile`:

```
from shamrin/zpugcc

add zpu /root/zpu
add host /root/host
run mkdir -p /root/zpu/build && cd /root/zpu/build && cmake .. && make
```

You can then run `docker build` and copy the result with `docker cp`. For example:

```
docker build --rm -t zpu-build .
docker cp $(docker run -d zpu-build true):/root/zpu/build/umtrx/umtrx_txrx_uhd.bin .
```

**Note:** building with `docker run -v` is easier than with `docker build` and `docker cp`, but `-v` option doesn't work on Mac OSX or Windows, [yet][bradfitz].

[bradfitz]: https://github.com/dotcloud/docker/issues/4023

### Rebuilding the container

**(optional)**

```
docker build --rm -t shamrin/zpugcc .
docker push shamrin/zpugcc
```

### Rebuilding 32-bit Ubuntu container

**(optional)**

On any Ubuntu/Debian (despite the warning, Docker is not required at this point: because `-t` option):

```
sudo apt-get install debootstrap
curl -O https://raw.githubusercontent.com/dotcloud/docker/fa8f89c5212f109/contrib/mkimage-debootstrap.sh
chmod +x mkimage-debootstrap.sh
./mkimage-debootstrap.sh -a i386 -t ubuntu32.tar.bz2 precise
```

Copy `ubuntu32.tar.bz2` to any platform supported by Docker and run:

```
cat ubuntu32.tar.bz2 | docker import - shamrin/ubuntu32
docker run -i -t shamrin/ubuntu32 bash -c 'apt-get -y install file; file /bin/bash'
```

The last command should output `ELF 32-bit`:

```
/bin/bash: ELF 32-bit LSB executable, Intel 80386…
```

Pushing to Docker registry:

```
docker push shamrin/ubuntu32
```
