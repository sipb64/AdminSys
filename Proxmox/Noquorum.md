# Pour que les machines du cluster ne soit pas en lecture seule si les autres machines sont éteintes

## Possible script (adrienlinuxtricks)
#! /bin/bash
sleep 30
pvecm expected 1

## cron
@reboot /root/noquorum.sh
1 0 * * * /root/noquorum.sh

## Possibilité de save via cron 


