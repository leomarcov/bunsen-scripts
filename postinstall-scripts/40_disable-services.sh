#!/bin/bash
# ACTION: Disable some stupid services
# DESC: For most users stupid services are: NetworkManager-wait-online.service, ModemManager.service, pppd-dns.service
# DEFAULT: y

systemctl disable NetworkManager-wait-online.service
systemctl disable ModemManager.service
systemctl disable pppd-dns.service
