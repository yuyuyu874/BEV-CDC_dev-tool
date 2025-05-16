#!/bin/bash

script_path=$(realpath "$0")
script_dir=$(dirname "$script_path")

source $script_dir/config.sh

dir_adb=$(echo "$dir_adb" | sed 's/ /\\ /g')

# 追加したい設定内容
path_adb="$dir_adb/adb.exe"
path_fastboot="$script_dir/fastboot/command.sh"
path_pcat="$script_dir/pcat/command.sh"
path_qnx="$script_dir/qnx/commands/command.sh"

alias_adb="alias adb='$path_adb'"
alias_fastboot="alias fastboot='$path_fastboot'"
alias_pcat="alias pcat='$path_pcat'"
alias_qnx="alias qnx='$path_qnx'"

# .bashrc のパス
bashrc_file="$HOME/.bashrc"


echo "========================================"
echo "adb setup"
echo "========================================"
# 設定がすでに存在するか確認し、存在しない場合に追加
if ! grep -Fxq "$alias_adb" "$bashrc_file"; then
    echo "$alias_adb" >> "$bashrc_file"
    echo "Added new setting to .bashrc: $alias_adb"
else
    echo "Setting already exists in .bashrc: $alias_adb"
fi

echo

echo "========================================"
echo "fastboot setup"
echo "========================================"
# 設定がすでに存在するか確認し、存在しない場合に追加
if ! grep -Fxq "$alias_fastboot" "$bashrc_file"; then
    echo "$alias_fastboot" >> "$bashrc_file"
    echo "Added new setting to .bashrc: $alias_fastboot"
else
    echo "Setting already exists in .bashrc: $alias_fastboot"
fi

echo

echo "========================================"
echo "pcat setup"
echo "========================================"
# 設定がすでに存在するか確認し、存在しない場合に追加
if ! grep -Fxq "$alias_pcat" "$bashrc_file"; then
    echo "$alias_pcat" >> "$bashrc_file"
    echo "Added new setting to .bashrc: $alias_pcat"
else
    echo "Setting already exists in .bashrc: $alias_pcat"
fi
echo

echo "========================================"
echo "qnx setup"
echo "========================================"
# 設定がすでに存在するか確認し、存在しない場合に追加
if ! grep -Fxq "$alias_qnx" "$bashrc_file"; then
    echo "$alias_qnx" >> "$bashrc_file"
    echo "Added new setting to .bashrc: $alias_qnx"
else
    echo "Setting already exists in .bashrc: $alias_qnx"
fi
echo

# .bashrc を再読み込み
source "$bashrc_file"
echo ".bashrc has been reloaded."

find $script_dir -type f -name "*.sh" -exec chmod +x {} \;
echo
echo "========================================"