#!/bin/bash
file_path=$1
file_name=$(basename "$file_path")

# ファイル名チェック（ver_info.txtを上書きしないようにする）
if [ "$file_name" == "ver_info.txt" ]; then
    echo "ver_info.txt は指定できません。"
    exit 1
fi

# ファイルの有無を確認
if [ ! -e "$file_path" ]; then
    echo "$file_path は存在しません。"
    exit 1
fi

# ファイルを LV に転送
echo "[LOGS] $file_path を (LV) /firmware/verinfo/ に転送します。"
"$dir_adb/adb.exe" push "$file_path" "/firmware/verinfo/" 2>/dev/null
if [ $? -ne 0 ]; then
    echo "ファイルの転送が失敗しました"
    exit 1
fi
echo "[LOGS] $file_path を (LV) /firmware/verinfo/ に転送しました。"

"$dir_adb/adb.exe" shell "sync; sync; sync; sync; sync; sync; sync; sync; sync; sync; sync; sync; sync; sync; sync; sync; exit"

. $script_dir/reset.sh

echo "[LOGS] qnx shell に接続します。"

"$dir_teraterm/ttpmacro.exe" /I push.ttl $port $file_name

"$dir_adb/adb.exe" shell rm -rf /firmware/verinfo/$file_name
echo "[LOGS] $file_name を (QNX) mnt/usr/bin/ に転送しました。"
