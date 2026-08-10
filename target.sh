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

function clean {
    if [[ ! -d "$(getCatalog)/target" ]]; then
        logError "Catalog \"$(getCatalog)/target\" doesn't exist."

        return 1
    fi

    cd "$(getCatalog)/target"

    lb clean

    if [ $? -ne 0 ]; then
        logError "Can't execute the \"lb clean\" command."

        return 2
    fi

    return 0
}

function target {
    if [[ ! -d "$(getCatalog)/src" ]]; then
        logError "Catalog \"$(getCatalog)/src\" doesn't exist."
        return 1
    fi

    if [ -d "$(getCatalog)/target" ]; then
        clean

        if [ $? -ne 0 ]; then
            logError "Can't clean the \"$(getCatalog)/target\" catalog."

            return 2
        fi
    fi

    rm -rf "$(getCatalog)/target/auto"
    cp -r "$(getCatalog)/src/." "$(getCatalog)/target/"

    cd "$(getCatalog)/target"

    lb config

    if [ $? -ne 0 ]; then
        logError "Can't execute the \"lb config\" command."

        return 3
    fi

    if [ ! -d "./hooks" ]; then
        logWarning "Can't find the \"$(pwd)/hooks\" catalog."
    else
        rm -rf "./config/hooks"
        mv "./hooks" "./config"
    fi

    if [ ! -d "./includes.binary" ]; then
        logWarning "Can't find the \"$(pwd)/includes.binary\" catalog."
    else
        rm -rf "./config/includes.binary"
        mv "./includes.binary" "./config"
    fi

    if [ ! -d "./includes.chroot" ]; then
        logWarning "Can't find the \"$(pwd)/includes.chroot\" catalog."
    else
        rm -rf "./config/includes.chroot"
        mv "./includes.chroot" "./config"
    fi

    if [ ! -d "./package-lists" ]; then
        logWarning "Can't find the \"$(pwd)/package-lists\" catalog."
    else
        rm -rf "./config/package-lists"
        mv "./package-lists" "./config"
    fi

    if [ ! -d "./packages.chroot" ]; then
        logWarning "Can't find the \"$(pwd)/packages.chroot\" catalog."
    else
        rm -rf "./config/packages.chroot"
        mv "./packages.chroot" "./config"
    fi

    return 0
}

function main {
    if [[ $EUID -ne 0 ]]; then
        logError "This script must be run as root."
        return 1
    fi

    target

    if [ $? -ne 0 ]; then
        logError "Can't execute the \"target\" stage."

        return 2
    fi

    if [ ! -d "$(getCatalog)/target" ]; then
        logError "Catalog \"$(getCatalog)/target\" doesn't exist."
        
        return 3
    fi

    cd "$(getCatalog)/target"

    lb build

    if [ $? -ne 0 ]; then
        logError "Can't execute the \"lb build\" command."

        return 4
    fi

    cd "$(getCatalog)"

    return 0
}

configuration

main
