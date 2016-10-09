FROM ubuntu:16.04
MAINTAINER Tom Molesworth "tom@audioboundary.com"
ENV REFRESHED_AT 2016-10-05

RUN apt-get update
RUN apt-get install -y build-essential autopoint autoconf wget bison cmake flex gperf libtool python ruby scons unzip intltool libtool libltdl-dev git protobuf-compiler libffi-dev pkg-config cmake-curses-gui g++-multilib libc6-dev-i386 autoconf automake autopoint bash bison bzip2 flex gettext git g++ gperf intltool libffi-dev libgdk-pixbuf2.0-dev libtool libltdl-dev libssl-dev libxml-parser-perl make openssl p7zip-full patch perl pkg-config python ruby scons sed unzip wget xz-utils libtool-bin gobject-introspection libgirepository1.0-dev valac gtk-doc-tools libgsf-1-dev uuid-dev bison

WORKDIR /opt
RUN git clone https://github.com/mxe/mxe.git
RUN git clone https://github.com/tm604/gcab.git
RUN git clone https://github.com/tm604/msitools.git
WORKDIR /opt/mxe

RUN make download-gcc
RUN make download-boost
RUN make download-openssl
RUN make download-pthreads
RUN make download-cmake

ADD settings.mk /opt/mxe/settings.mk

WORKDIR /opt/gcab
RUN ./autogen.sh
RUN make
RUN ./configure --disable-shared --enable-static
RUN make install

WORKDIR /opt/msitools
RUN ./autogen.sh && ./configure --disable-shared --enable-static
RUN cd include && make && make install
RUN cd libmsi && make && make install
RUN make
RUN make install
RUN ldconfig

WORKDIR /opt/mxe
RUN make gcc boost cmake openssl wxwidgets
RUN make portaudio

CMD ["/bin/bash"]

