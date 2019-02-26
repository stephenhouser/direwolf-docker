# Dire Wolf Docker Container

Dire Wolf is a software sound-card for Amateur Radio packet modem (or TNC) and APRS encoding and decoding. It can be used stand-alone to observe APRS traffic, as a tracker, digipeater, APRStt gateway, or Internet Gateway (IGate). For more information refer to [wb2osz/direwolf](https://github.com/wb2osz/direwolf).

This repository is a Docker packaged version of Dire Wolf with a few modifications to remove some of the terminal font coloring and have it work properly on my Ubuntu Linux system (16.04 LTS). It was  forked from [f4hlv/direwolf-docker](https://github.com/f4hlv/direwolf-docker).

## Running The Container

The included `docker-compose.yaml` gives a good overview of how I run this container and the devices/volumes that need to be mapped for proper communication with the underlying devices. The one trick is mapping the `/dev/hidrawX` device if you are using a sound-card with Push To Talk (PTT) control from Dire Wolf. More detail on device configuration is beyond the scope of this documentation, however the Dire Wolf manual can be of some assistance.

Here's an example of running using a properly configured `direwolf.conf` with a CM108-based sound-card that has been [modified to allow PTT](http://www.garydion.com/projects/usb_fob/).

```
docker run -d \
    --volume direwolf.conf:/direwolf/direwolf.conf \
    --device=/dev/snd:/dev/snd \
    --device=/dev/hidraw1:/dev/hidraw1 \
    stephenhouser/direwolf direwolf \
```
