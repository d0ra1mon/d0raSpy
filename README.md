# d0raSpy - Spy Tool

<p align="center">
 <img alt="Shell" src="https://img.shields.io/badge/Shell_Script-121011?style=for-the-badge&logo=gnu-bash&logoColor=white">
 <img alt="OpenWrt" src="https://img.shields.io/badge/OpenWrt-00B5E2?style=for-the-badge&logo=OpenWrt&logoColor=white">
</p>

<p align="center"><img src="image/Compromised Router.png"></p> 

## Wath is?
Inspired by the CIA's Top Secret projects revealed by Wikileaks:
- Project Elsa
- Project OutlawCountry
- Project Extending

## Features

| Features | |                                 
| --------- | --------- |
| Get Public IP | :heavy_check_mark: |
| Find all devices | :heavy_check_mark: |
| Intercept all traffic | :heavy_check_mark: |
| Send report to attacker| :heavy_check_mark: |
| Get system info | :heavy_check_mark: |
| Self-removal | :heavy_check_mark: |
| Scheduled Reverse shell | :heavy_check_mark: |
| Enable port forwarding | :heavy_check_mark: |
| Dump Shadow Passwords | :heavy_check_mark: |
| Exploit vulnerable devices | :x: |
| Find all Networks | :x: |
| DNS poisoning | :x: |


## Supported Devices
The scripts were written in bash and tested on a Raspberry Pi 4B with OpenWrt, so they should work for most routers on the market. 

To properly install and configure OpenWrt for a Raspberry follow this guide:
https://www.ixonae.com/configure-a-raspberry-pi-as-a-secure-wifi-access-point-with-open-wrt/

## How setup the Bot Telegram

1. Open `Telegram` > search `BotFather` > type `/newbot` > set name `name_bot` > `get HTTP API token` 
2. Search `RawDataBot` > Click `Start` > The Telegram bot will send a message with your account info. Scroll down and find chat. Your chat ID number is listed below, next to id
