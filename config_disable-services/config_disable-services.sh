#!/bin/bash
# ACTION: Config some stupid services for not start during boot
# INFO: For most users stupid services are: NetworkManager-wait-online.service, ModemManager.service, pppd-dns.service
# DEFAULT: y

# Check root
[ "$(id -u)" -ne 0 ] && { echo "Must run as root" 1>&2; exit 1; }

#systemctl disable NetworkManager-wait-online.service
systemctl disable ModemManager.service
systemctl disable pppd-dns.service
