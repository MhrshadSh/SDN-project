# SDN final Project
# eBPF Protocol Classifier

This project implements an eBPF-based network protocol classifier that identifies and counts HTTP, DNS, and SSH traffic based on port numbers. The program runs in the Linux kernel using XDP (eXpress Data Path) to process packets at the earliest possible point in the network stack.

## Features

- Protocol Classification:
  - HTTP/HTTPS (ports 80, 443)
  - DNS (port 53)
  - SSH (port 22)

- Statistics Tracking:
  - Packet count per protocol
  - Byte count per protocol
  - Real-time logging of detected protocols

## Requirements

- Linux kernel 4.8 or newer
- LLVM/Clang compiler
- BPF Compiler Collection (BCC) tools
- Root privileges for loading the eBPF program

## Building

1. Clean any existing build artifacts:
```bash
make clean
```

2. Build the eBPF program:
```bash
make
```

The compiled eBPF object file will be created in the `.output` directory.

## Usage

1. Load the eBPF program onto a network interface (replace `eth0` with your interface):
```bash
sudo bpftool prog load .output/netprog.bpf.o /sys/fs/bpf/netprog type xdp
```

2. Attach the program to an interface:
```bash
sudo bpftool net attach xdp id <PROG_ID> dev eth0
```

3. View the trace pipe for protocol detection messages:
```bash
sudo cat /sys/kernel/debug/tracing/trace_pipe
```

4. View protocol statistics:
```bash
sudo bpftool map dump id <MAP_ID>
```

## Protocol Detection

The program identifies protocols based on the following ports:
- HTTP/HTTPS: Ports 80 and 443
- DNS: Port 53
- SSH: Port 22

## Statistics

The program maintains counters for each protocol type:
- Number of packets
- Total bytes

## License

This project is licensed under the GPL-2.0 License.

## Notes

- The program processes both IPv4 and IPv6 traffic
- All packets are passed through (XDP_PASS)
- Statistics are maintained using eBPF maps
- Protocol detection is based on port numbers only
