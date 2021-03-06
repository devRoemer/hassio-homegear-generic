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

* KNX
* EnOcean
* Beckhoff BK90x0
* HomeMatic BidCoS
* HomeMatic Wired
* Insteon
* Philips Hue
* Sonos
* MAX!
* Intertechno
* Kodi
* IP cams

See [homegear.eu](https://homegear.eu/) for further details.

## Installation

Add this repo to Hassio as [described here](https://home-assistant.io/hassio/installing_third_party_addons/) and install the **Homegear** add-on.

Don't get nervous after you've hit **Install**. Depending on your hardware, it may take up to half an hour before Homegear is installed. Once it appears in the list of installed add-ons, you'll have to **open** and **start** it.

## How it works

A folder named `homegear/` will be added to the `/config` directory of your Hassio installation. `/config` is where all your other Home Assistant config files live as well. You can [access it via Samba](https://home-assistant.io/addons/samba/) for example. `/config/homegear` corresponds to `/etc/homegear` in Homegear. You will need to add your configuration according to the [Homegear docs](https://doc.homegear.eu/data/homegear/configuration.html).

Homegear usually stores its database and other variable data in `/var/lib/homegear`. This directory will be mapped to `/share/homegear/lib` in Hassio. **It is advisable to perform backups of this folder!**

Homegear logs will be in `/share/homegear/log`.

[project-stage-shield]: https://img.shields.io/badge/project%20stage-stable-green.svg
[license-shield]: https://img.shields.io/github/license/devRoemer/hassio-homegear-generic.svg
[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[armhf-shield]: https://img.shields.io/badge/armhf-yes-green.svg
[armv7-shield]: https://img.shields.io/badge/armv7-yes-green.svg
[i386-shield]: https://img.shields.io/badge/i386-yes-green.svg
[github-actions]: https://github.com/devRoemer/hassio-homegear-generic/actions
[github-actions-shield]: https://github.com/devRoemer/hassio-homegear-generic/workflows/CI/badge.svg
[maintenance-shield]: https://img.shields.io/maintenance/yes/2021.svg
