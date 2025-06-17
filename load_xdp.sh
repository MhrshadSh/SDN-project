#!/bin/bash

# Replace 'eth0' with your actual network interface name
INTERFACE="eth0"

# Load the XDP program
ip link set dev $INTERFACE xdp obj netprog.bpf.o sec xdp_prog_protocol_classifier

# Show the loaded program
ip link show dev $INTERFACE

echo "XDP program loaded. You can now run the test commands."
echo "To unload the program later, run: ip link set dev $INTERFACE xdp off" 