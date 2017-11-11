FROM ubuntu:14.04

#
# ========== Update packages and install dependencies
# ========== List of dependencies from INSTALL file
#

RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y curl libx264-dev libexpat1-dev libboost-dev libboost-system-dev libboost-regex-dev libboost-thread-dev libboost-filesystem-dev yasm libopencore-amrnb-dev libopencore-amrwb-dev libtheora-dev libvorbis-dev zlib1g-dev libbz2-dev libltdl-dev libvpx-dev libfaac-dev libmp3lame-dev g++ build-essential make cmake automake python

# GUI:
# libgtk2.0-dev libcairo2-dev python-gtk2-dev python-cairo-dev

# Optional features:
# libsdl-dev libpcap-dev

#
# ========== Download, unpack and fix source tarball
#

WORKDIR /opt
RUN curl -sL http://sirannon.atlantis.ugent.be/download.php?file=sirannon-1.0.0.tar.gz > sirannon-1.0.0.tar.gz
WORKDIR /opt/sirannon
RUN tar --strip-components=1 -xzf /opt/sirannon-1.0.0.tar.gz \
	&& find -name CMakeCache.txt -delete \
	&& find -name configure -o -name version.sh -exec chmod 777 {} \;


# The bootstrap.py script is executed above
# Other options: --disable-ffmpeg --disable-jrtplib
# RUN python/bootstrap.py --disable-GUI

#
# ========== Build contained dependencies
# ========== Build commands based on python/bootstrap.py (GUI excluded)
#

WORKDIR /opt/sirannon/libs/ffmpeg-0.9
RUN sh ./configure --enable-debug=3 --disable-vaapi --disable-ffmpeg --disable-ffprobe --disable-ffserver --disable-ffplay --enable-memalign-hack --enable-version3 --enable-nonfree --enable-gpl --enable-postproc --enable-pthreads --enable-libvorbis --enable-libfaac --enable-libmp3lame --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libtheora --enable-libvpx --enable-libx264 --extra-cflags="-fexceptions" \
	&& make


# Alternative for building ffmpeg
# WORKDIR /opt/sirannon/libs/ffmpeg-0.9
# RUN sh ./configure --disable-vaapi --disable-ffmpeg --disable-ffserver --disable-ffplay --disable-ffprobe --enable-memalign-hack --enable-version3 --enable-nonfree --enable-gpl --enable-postproc --enable-pthreads --enable-libvpx --extra-cflags="-fexceptions" && make


WORKDIR /opt/sirannon/libs/jrtplib-3.9.1
RUN cmake --disable-jthread --disable-memory . && make

#
# ========== Configure and build the Sirannon server
#

WORKDIR /opt/sirannon
RUN autoreconf -i && ./configure && make && make install

# ./configure --without-boost-filesystem --without-boost-regex
