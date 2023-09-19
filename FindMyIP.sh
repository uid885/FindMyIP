#!/bin/bash
# Author  :         Christo Deale                  
# Date    :         2023-07-11             
# FindMyIP:         Utility to scan connected devices & list
#                   internal & external IP Addresses

# Fetch full hostname
hostname=$(hostname -f)

# Fetch connected devices and their internal IP addresses using nmcli
devices=$(nmcli device show | awk '/DEVICE/ {device=$2} /IP4.ADDRESS/ {split($2,a,"/"); print device"\t"a[1]}')

# Fetch external IP address using OpenDNS
external_ip=$(dig +short myip.opendns.com @resolver1.opendns.com)

# Calculate the maximum lengths of each field
max_hostname_length=$(echo -e "$hostname" | awk '{print length}')
max_device_length=$(echo "$devices" | awk -F'\t' '{print length($1)}' | sort -nr | head -1)
max_internal_ip_length=$(echo "$devices" | awk -F'\t' '{print length($2)}' | sort -nr | head -1)
max_external_ip_length=$(echo -e "$external_ip" | awk '{print length}')

# Output hostname, device, internal IP, and external IP in a table
printf "%-*s\t%-*s\t%-*s\t%s\n" $max_hostname_length "Hostname" $max_device_length "Device" $max_internal_ip_length "Internal IP" "External IP"
while IFS=$'\t' read -r device internal_ip; do
    printf "%-*s\t%-*s\t%-*s\t%s\n" $max_hostname_length "$hostname" $max_device_length "$device" $max_internal_ip_length "$internal_ip" "$external_ip"
done <<< "$devices"
