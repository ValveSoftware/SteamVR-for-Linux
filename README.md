# SteamVR Release Notes and Known Issues

**This is a development release**. It is intended to allow developers to start creating SteamVR content for Linux platforms. Limited hardware support is provided.

**SteamVR and VR apps require a modern linux distribution with up to date graphics drivers. Ubuntu >= 20 or Arch for instance**.

For discussions and questions, please use the SteamVR for Linux forum at http://steamcommunity.com/app/250820/discussions/5/.

For bugs, please file an issue on this github issue tracker. https://github.com/ValveSoftware/SteamVR-for-Linux/issues

## GRAPHICS DRIVER REQUIREMENTS

SteamVR is built on top of the Vulkan API and requires the latest Vulkan drivers.

### NVIDIA on Ubuntu

We recommend using the latest NVIDIA drivers from the "Graphics Drivers" PPA at https://launchpad.net/~graphics-drivers/+archive/ubuntu/ppa

### AMD on Ubuntu

We recommend using the latest mesa drivers from the PPA at https://launchpad.net/~kisak/+archive/ubuntu/kisak-mesa

## NATIVE DEVELOPMENT

Version 1.0.7 of the OpenVR SDK has full support for Linux platforms: https://github.com/ValveSoftware/openvr
