# QnD-WebFind
Quick and Dirty Webserver Finder

This is a quick and dirty solution to find webservers using cURL.
I made this in preparation for the OSCP exam so I could get a quick glimpse at the various webservers I can enumerate while my automated scanners are running.

This script will curl an IP address or target file on ports 80, 8000, 8080, 8888, 443, & 8443.

Example:
```bash
./webfind.sh targets.txt

[*] 200 : http://192.168.10.10:80/
[*] 200 : http://192.168.10.10:8080/
[*] 200 : http://192.168.10.11:80/
[*] 200 : http://192.168.10.11:443/
[*] 200 : http://192.168.10.15:8888/
```
