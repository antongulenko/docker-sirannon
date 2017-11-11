# hub.docker.com/r/antongulenko/sirannon
FROM antongulenko/sirannon-src

# This images does not build, the autoreconf below does not work.

#
# ========== Configure and build the Sirannon server
#

WORKDIR /opt/sirannon
RUN autoreconf -i && ./configure && make && make install

# ./configure --without-boost-filesystem --without-boost-regex

