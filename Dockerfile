FROM debian as builder
MAINTAINER stephenhouser@gmail.com

# Dependencies
RUN apt-get update \
    && apt-get install --no-install-recommends -y git gcc g++ make cmake libasound2-dev libudev-dev libhamlib-dev\
    && apt-get install --no-install-recommends -y curl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Build Direwolf
RUN git clone https://github.com/wb2osz/direwolf.git \
    && cd direwolf \
    && git checkout dev \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make -j4 \
    && make install \
    && make install-conf 

# # Remove build dependencies and clean up
# RUN apt-get remove -y git gcc g++ make cmake libasound2-dev libudev-dev \
#     && apt-get clean \
#     && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ~/.cache

FROM debian

RUN apt-get update \
    && apt-get install --no-install-recommends -y curl ca-certificates libasound2 libhamlib2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ~/.cache

COPY --from=builder /usr/local/ /usr/local/

#COPY direwolf.conf /etc/direwolf.conf
VOLUME /direwolf
WORKDIR /direwolf

CMD direwolf -t 0 -c /etc/direwolf.conf

# docker run -it -p "8888:8000" -v /share/homes/houser/containers/direwolf/direwolf-N1SH.conf:/etc/direwolf.conf --device /dev/snd:/dev/snd --device /dev/hidraw0:/dev/cm108 stephenhouser/direwolf:latest