#!/bin/bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 ; pwd -P)
cd "$SCRIPT_DIR"

swiftc -O main.swift -o clipboard-bridge
echo "Built: $SCRIPT_DIR/clipboard-bridge"
