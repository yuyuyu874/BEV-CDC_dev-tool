#!/bin/bash

usage() {
    echo "Error: Invalid number of arguments."
    echo "Usage: pcat [command] [arguments(optional)]"
    echo "commands:"
    echo "  list                   : List repositories of available SoC Versions"
    echo "  get <repo_path>        : Get SoC file"
    echo "  all                    : flush all domains"
    echo "  main                   : flush main domain"
    echo "  sail                   : flush sail domain"
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
    list)
        . $script_dir/pcatGetVerList.sh
        ;;
    get)
        # 引数チェック
        if [ $# -ne 2 ]; then
            echo "Error: Invalid number of arguments."
            echo "Usage: pcat get <repo_path>"
            exit 1
        fi
        . $script_dir/pcatGetVerUpFile.sh "$2"
        ;;
    all)
        . $script_dir/pcatAllVersionUp.sh
        ;;
    main)
        . $script_dir/pcatMainVersionUp.sh
        ;;
    sail)
        . $script_dir/pcatSailVersionUp.sh
        ;;
    *)
        echo "Invalid command: $1"
        usage
        ;;
esac