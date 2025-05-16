#!/bin/bash

usage() {
    echo "Error: Invalid number of arguments."
    echo "Usage: fastboot [command] [arguments(optional)]"
    echo "commands:"
    echo "  lv          : flash LV partition"
    exit 1
}

if [ $# -eq 0 ]; then
    usage
    exit 1
fi

script_path=$(realpath "$0")
script_dir=$(dirname "$script_path")
dev_tool_dir=$(dirname "$script_dir")

source "$dev_tool_dir/config.sh"


case "$1" in
    lv)
        . $script_dir/lv.sh
        ;;
    *)
        echo "Invalid command: $1"
        usage
        ;;
esac