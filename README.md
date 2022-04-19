# Home Assistant Add-on: Homegear

![Project Stage][project-stage-shield]
[![License][license-shield]](LICENSE.md)

![Supports aarch64 Architecture][aarch64-shield]
![Supports amd64 Architecture][amd64-shield]
![Supports armhf Architecture][armhf-shield]
![Supports armv7 Architecture][armv7-shield]
![Supports i386 Architecture][i386-shield]

[![Github Actions][github-actions-shield]][github-actions]
![Project Maintenance][maintenance-shield]

This add-on repository contains the Homegear add-on for Hassio (Home Assistant).

## What is Homegear

Homegear is a free and open source program to interface your home automation devices or services with your home automation software or scripts. Currently supported are the following device families/systems:

- KNX
- EnOcean
- Beckhoff BK90x0
- HomeMatic BidCoS
- HomeMatic Wired
- Insteon
- Philips Hue
- Sonos
- MAX!
- Intertechno
- Kodi
- IP cams

See [homegear.eu](https://homegear.eu/) for further details.

## Installation and configuration

Have a look at the [wiki](https://github.com/devRoemer/hassio-homegear-generic/wiki) to find out how to install this addon and configure homegear.

## How to contribute

PullRequests are welcome. Just keep in mind that this addon supports 5 cpu architectures. There is a ci build running on every commit to ensures that the docker images can still be built on every architecture. Also it runs Shellcheck and other validations to detect common problems and verify the code style. What it can't do is to test the entrypoint script on every arch => Be careful on editing.

[project-stage-shield]: https://img.shields.io/badge/project%20stage-stable-green.svg
[license-shield]: https://img.shields.io/github/license/devRoemer/hassio-homegear-generic.svg
[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[armhf-shield]: https://img.shields.io/badge/armhf-yes-green.svg
[armv7-shield]: https://img.shields.io/badge/armv7-yes-green.svg
[i386-shield]: https://img.shields.io/badge/i386-no-red.svg
[github-actions]: https://github.com/devRoemer/hassio-homegear-generic/actions
[github-actions-shield]: https://github.com/devRoemer/hassio-homegear-generic/workflows/CI/badge.svg
[maintenance-shield]: https://img.shields.io/maintenance/yes/2022.svg
