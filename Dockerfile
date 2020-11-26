FROM alpine

COPY textcolor.patch /tmp/textcolor.patch
RUN apk add --no-cache git alsa-lib alsa-lib-dev linux-headers build-base eudev-dev eudev && \
    git clone https://github.com/wb2osz/direwolf.git /tmp/direwolf && \
    echo "#include <unistd.h>" > /usr/include/sys/unistd.h && \
    cd /tmp/direwolf && \
    git apply /tmp/textcolor.patch && \
    sed -i 's/--mode=/-m /g' Makefile.linux && \
    sed -i 's/cp -n/cp/g' Makefile.linux && \
    CFLAGS=-D__FreeBSD__ make && make install && \
    cd / && rm -r /tmp/direwolf /usr/include/sys/unistd.h && rm /tmp/textcolor.patch && \
    find /usr/local/bin -type f -exec strip -p --strip-debug {} \; && \
    apk del git alsa-lib-dev linux-headers build-base eudev-dev && \
	mkdir -p /direwolf

#COPY direwolf.conf /direwolf/direwolf.conf
WORKDIR /direwolf

CMD direwolf -t 0 -c /direwolf/direwolf.conf

