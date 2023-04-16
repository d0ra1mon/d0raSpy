# d0raSpy - Spy Tool

<p align="center">
 <img alt="Shell" src="https://img.shields.io/badge/Shell_Script-121011?style=for-the-badge&logo=gnu-bash&logoColor=white">
</p>

## Wath is?
Inspired by the CIA's Top Secret projects revealed by Wikileaks:
- Project Elsa
- Project OutlawCountry
- Project Extending

## Features

d0raSpy, once installed on the victim router, allows you to: 

| Features | |
| --------- | --------- |
| Get Public IP | :heavy_check_mark: |
| Find all devices | :heavy_check_mark: |
| Intercept all traffic | :heavy_check_mark: |
| Send report to attacker| :heavy_check_mark: |
| Get system info | :heavy_check_mark: |
| Self-removal | :heavy_check_mark: |
| Exploit vulnerable devices | :x: |
| Find all Networks | :x: |
| DNS poisoning | :x: |
| Add to black list a specific device | :x: |
| Deny service to certain clients | :x: |
| Dump Passwords | :x: |
| Create a secondary root account | :x: |
| Remote shell | :x: |
| Enable port forwarding | :x: |


## Configure Raspberry

Follow this guide: 
https://www.ixonae.com/configure-a-raspberry-pi-as-a-secure-wifi-access-point-with-open-wrt/

## How the scripts works

- The script "spy.sh" scan,get public ip, intercept traffic of the network (max 200 Mb), and send the report via Telegram 
- The script "scan.sh" scan and get public ip, send the report via Telegram and make a autouinstall
