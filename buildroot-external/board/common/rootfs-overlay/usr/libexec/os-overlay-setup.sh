#! /bin/bash

set -e

OVERLAY="/mnt/overlay"

overlay_paths=(
  "${OVERLAY}/etc"
  "${OVERLAY}/.atomic"
)

for overlay_path in "${overlay_paths[@]}"; do
  mkdir -p "${overlay_path}"
done
