FROM debian as builder
LABEL Stephen Houser <stephenhouser@gmail.com>

# Build container for Direwolf
# Dependencies
RUN apt-get update \
    && apt-get install --no-install-recommends -y git gcc g++ make cmake libasound2-dev libudev-dev libhamlib-dev\
    && apt-get install --no-install-recommends -y curl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/wb2osz/direwolf.git \
    && cd direwolf \
    && git checkout dev \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make -j4 \
    && make install \
    && make install-conf 

# Runtime container for Direwolf
FROM debian

RUN apt-get update \
    && apt-get install --no-install-recommends -y curl ca-certificates libasound2 libhamlib2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ~/.cache

COPY --from=builder /usr/local/ /usr/local/

#COPY direwolf.conf /etc/direwolf.conf
CMD direwolf -t 0 -c /etc/direwolf.conf

