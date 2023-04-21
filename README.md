# d0raSpy - Spy Tool

<p align="center">
 <img alt="Linux" src="https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black">
 <img alt="Shell" src="https://img.shields.io/badge/Shell_Script-121011?style=for-the-badge&logo=gnu-bash&logoColor=white">
 <img alt="Telegram" src="https://img.shields.io/badge/Telegram-2CA5E0?style=for-the-badge&logo=telegram&logoColor=white">
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
| Exploit vulnerable devices | :x: |
| Find all Networks | :x: |
| DNS poisoning | :x: |
| Dump Passwords | :x: |
| Enable port forwarding | :x: |


## Supported Devices
The scripts were written in bash and tested on a Raspberry Pi 4B with OpenWrt, so they should work for most routers on the market. 

To properly install and configure OpenWrt for a Raspberry follow this guide:
https://www.ixonae.com/configure-a-raspberry-pi-as-a-secure-wifi-access-point-with-open-wrt/

Revers Shell generator: 
https://www.revshells.com/

## How the scripts works

- The script `spy.sh` scan,get public ip, intercept traffic of the network (max 200 Mb), and send the report via Telegram. This script is permanent and should be placed inside crontab.
- The script `scan.sh` scan and get public ip, send the report via Telegram and make a autouinstall. This script is temporary, in fact it self-removes when sending the report via Telegram.

## Building a C2  
https://0xrick.github.io/misc/c2/
