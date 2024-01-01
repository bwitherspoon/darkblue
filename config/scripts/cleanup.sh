#!/usr/bin/env bash

set -oue pipefail

echo "Removing repositories"

rm -f /etc/yum.repos.d/vscode.repo