#!/bin/bash

echo "Testing HTTP packets..."
curl -s http://example.com > /dev/null

echo "Testing HTTPS packets..."
curl -s https://example.com > /dev/null

echo "Testing DNS packets..."
dig example.com > /dev/null

echo "Testing SSH packets..."
ssh -o ConnectTimeout=1 nonexistent@localhost 2>/dev/null

echo "Tests completed. Check the kernel trace pipe for results:"
echo "Run this in another terminal: cat /sys/kernel/debug/tracing/trace_pipe" 