=======
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

## 🧪 Tests

This section outlines how to test the protocol counter XDP program by generating traffic from `h0` to `h1`. The XDP program is attached to `r0`'s `veth1` and counts HTTP, DNS, and SSH traffic over both IPv4 and IPv6.

---

### 1️⃣ View XDP Map in Real-Time

Open the `r0` tmux window and run:

```bash
watch bpftool map dump pinned /sys/fs/bpf/netprog/maps/protocol_stats_map
```
### 2️⃣ Run Test Cases from h0

Open the h0 tmux window and use the following commands.
### 🌐 HTTP Tests
#### HTTP over IPv4
```bash
curl http://10.0.2.1 --connect-timeout 1
```
#### HTTP over IPv6
```bash
curl -g -6 'http://[beef::1]' --connect-timeout 1
```
✅ Optional: On h1, start a web server
python3 -m http.server 80

### 🧭 DNS Tests
#### DNS over IPv4
```bash
dig @10.0.2.1 example.com
```
or use "curl example.com". As it will generate a dns msg to resolve example.com
#### DNS over IPv6
```bash
dig @beef::1 example.com
```

✅ Optional: On h1, start a DNS server
dnsmasq --no-daemon

### 🔐 SSH Tests
#### SSH over IPv4
```bash
ssh -o StrictHostKeyChecking=no -o ConnectTimeout=1 user@10.0.2.1
```
#### SSH over IPv6
```bash
ssh -o StrictHostKeyChecking=no -o ConnectTimeout=1 user@[beef::1]
```

## License

This project is licensed under the GPL-2.0 License.

## Notes

- The program processes both IPv4 and IPv6 traffic
- All packets are passed through (XDP_PASS)
- Statistics are maintained using eBPF maps
<<<<<<< HEAD
- Protocol detection is based on port numbers only 
=======
- Protocol detection is based on port numbers only
>>>>>>> db3ffd5b6435ee552f2e5f99623c2f711d688d2e
