FROM tm604/mxe-build:latest
MAINTAINER Tom Molesworth "tom@audioboundary.com"
ENV REFRESHED_AT 2016-12-26
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
RUN make binutils
RUN make gcc
RUN make bfd gendef
RUN make boost cmake openssl geoip-database sqlite

CMD ["/bin/bash"]

