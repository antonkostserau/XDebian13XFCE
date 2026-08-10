#!/bin/bash

function configuration {
    SUPER_CATALOG="$(cd "$(dirname "$0")" && pwd)"
}

function log {
    local date=$(date)

    echo "[$1] [$date] $2"

    return 0
}

function logMessage {
    log "Message" "$1"

    return 0
}

function logWarning {
    log "Warning" "$1"

    return 0
}

function logError {
    log "Error" "$1"

    return 0
}

function getCatalog {
    echo "$SUPER_CATALOG"

    return 0
}

function main {
    qemu-system-x86_64                                          \
        -enable-kvm                                             \
        -cdrom $(getCatalog)/target/live-image-amd64.hybrid.iso \
        -cpu host                                               \
        -smp 4                                                  \
        -m 8G                                                   \
        -vga virtio                                             \
        -audiodev pa,id=snd0                                    \
        -device intel-hda                                       \
        -device hda-duplex,audiodev=snd0
}

configuration

main
