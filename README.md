# EIB
Sample Single RKE2 Longhorn Server Build

# Features
- Use and configuration of a secondary disk (based on disk size) to mount /var/lib/longhorn
- Use of Traefik instead of ingress-nginx (to be obsoleted in March)
    - Beware that the current EIB (1.3.1) doesn't package Treafik which means the image will be downloaded from the internet
    - This will be fixed in the next version: https://github.com/suse-edge/edge-image-builder/issues/820
- Use of a private RMT/RPM repo (geeko2.suse.lab) => needs to be changed

# Build
- From the directory containing steph.yaml
```
CONFIG_DIR=.
sudo podman run --rm -it --privileged -v $CONFIG_DIR:/eib registry.suse.com/edge/3.4/edge-image-builder:1.3.1 build --definition-file steph.yaml
```
