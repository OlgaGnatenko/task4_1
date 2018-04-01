#!/bin/bash

dirpath=$(pwd)
outfile="$dirpath/task4_1.out"
if [ -f $outfile ]; then rm $outfile; fi; touch $outfile

echo "--- Hardware ---">>$outfile

CPU=$(cat /proc/cpuinfo | grep "model name" -m1 | cut -c14-)
if [ -z "${CPU// /}" ] ; then CPU="Unknown" ; fi
echo "CPU: $CPU">>$outfile

RAM=$(cat /proc/meminfo | grep MemTotal | awk '{print $2" " $3 }')
if [ -z "${RAM// /}" ] ; then RAM="Unknown" ; fi
echo "RAM: $RAM">>$outfile

MB_MAN=$(dmidecode -s baseboard-manufacturer)
MB_PN=$(dmidecode -s baseboard-product-name)
if [ -z "${MB_MAN// /}" ] ; then MB_MAN="" ; fi
if [ -z "${MB_PN// /}" ] ; then MB_PN="Unknown" ; fi
MB=$MB_MAN$MB_PN
echo "Motherboard: $MB">>$outfile

SSN=$(dmidecode -s system-serial-number)
if [ -z "${SSN}" ] ; then SSN="Unknown" ; fi
echo "System Serial Number: $SSN">>$outfile

echo "--- System ---">>$outfile

OS_DIST = $(cat /etc/*release* | grep PRETTY_NAME | cut  -d '"' -f 2)
echo "OS Distribution: $OS_DIST">>$outfile

KRNL = $(uname -r)
echo "Kernel version: $KRNL">>$outfile

INS_DATE = $(ls --time-style=long-iso -clt /var/log/installer | tail -n 1 | awk '{ print $6, $7 }')
echo "Installation date: $INS_DATE">>$outfile

HOSTNAME = $(hostname -f)
echo "Hostname: $HOSTNAME">>$outfile

UPTIME = $(uptime -p |  cut -d 'p' -f 2)
echo "Uptime: $UPTIME">>$outfile

PROC = $(ps -ax | sed  -e '1d' | wc -l)
echo "Processes running: $PROC">>$outfile

USR = $(who | wc -l)
echo "User logged in: $USR">>$outfile

echo "--- Network ---">>$outfile
for interf in $(ip addr list| grep "UP" | awk '{print $2}'|cut -d ":" -f 1|cut -d "@" -f 1)
   do
	IP=`ip addr list $interf | grep "inet "|awk '{print $2}'`
	if [ -z "${IP// /}" ] ; then IP="-" ; fi
	echo "$interf: $IP"
  done

