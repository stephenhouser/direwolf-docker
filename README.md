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
    --device=/dev/cm108:/dev/cm108 \
    stephenhouser/direwolf direwolf \
```

## CM108 Device for PTT

I've included a `udev` rule for the CM108 device that I have which adds a `/dev/cm108` device on the *host* system. This saves the hassle of changing device nodes when the host restarts and maps the CM108 to a known device node that can then be specified in the `direwolf.conf` file in the *container*. 

The file `90-cm108.rules` should be copied into the `/etc/udev/rules.d` directory on the *host*.
Then either reboot or reload the `udev` rules with the following command:

```
udevadm control --reload-rules && udevadm trigger
```

You should now see `/dev/cm108` on the *host* which can be mapped to the container and used for Push To Talk (PTT).

