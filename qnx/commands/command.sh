#!/bin/bash
set -e

usage() {
    echo "Usage: qnx [command] [arguments(optional)]"
    echo "commands:"
    echo "  shell           Connect to QNX shell"
    echo "  reset           Reset QNX device"
    echo "  push <file>     Push a file to (QNX) /mnt/usr/bin"
    exit 1
}

if [ $# -eq 0 ]; then
    usage
    exit 1
fi

script_path=$(realpath "$0")
script_dir=$(dirname "$script_path")
temp=$(dirname "$script_dir")
dev_tool_dir=$(dirname "$temp")

source "$dev_tool_dir/config.sh"

case "$1" in
    shell)
        . $script_dir/shell.sh
        ;;
    push)
        # 引数チェック
        if [ $# -ne 2 ]; then
            echo "Usage: $0 push <file_path> <dist_path>"
            exit 1
        fi
        . $script_dir/push.sh "$2"
        ;;
    reset)
        . $script_dir/reset.sh
        ;;
    *)
        echo "Invalid command: $1"
        usage
        ;;
esac
