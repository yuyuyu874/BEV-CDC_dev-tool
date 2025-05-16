#!/bin/bash
cd $work_dir
set -e

# PCATのパスを指定
PCAT="$script_dir/pcat.sh"

# pcat.shの出力を変数に格納
PCAT_DEV_INFO=$(. $PCAT -devices)

# シリアル番号を格納する配列を初期化
PCAT_DEV_SERIAL_NO=()

# 出力を行ごとに読み込む
while IFS= read -r line; do
    # 行に3番目の'|'が含まれているか確認
    if [[ $(echo "$line" | awk -F'|' '{print NF-1}') -ge 3 ]]; then
        # 3番目の'|'の後のSERIAL NUMBERを抽出
        TMP_DEV_SERIAL_NO=$(echo "$line" | awk -F'|' '{print $4}' | xargs)
        echo "SERIAL NUMBER: $TMP_DEV_SERIAL_NO"

        PCAT_DEV_SERIAL_NO+=("$TMP_DEV_SERIAL_NO")
    fi
done < <(echo "$PCAT_DEV_INFO")

# 2行目のSERIAL NUMBERを別の変数に格納
if [[ ${#PCAT_DEV_SERIAL_NO[@]} -ge 2 ]]; then
    VUP_DEVICE=${PCAT_DEV_SERIAL_NO[1]}
fi

if [[ -z "$VUP_DEVICE" ]]; then
    echo "Error: PCAT DEVICE is not found."
    exit 1
fi

echo "========================================"
echo "VUP_DEVICE: $VUP_DEVICE"
echo "========================================"

# Linuxのホームディレクトリを取得
HOME_DIR=$(pwd)
echo "HOME_DIR: $HOME_DIR"

# VerUp用ファイルの有無を確認
if [ ! -d ./out-collect_8255 ]; then
    echo "Error: out-collect_8255 is not found."
    exit 1
fi

if [ ! -d ./out-collect_8255/snapdragon-auto-hqx-4-5-6-0_test_device ]; then
    echo "Error: out-collect_8255/snapdragon-auto-hqx-4-5-6-0_test_device is not found."
    exit 1
fi

# out-collect_8255\snapdragon-auto-hqx-4-5-6-0_test_device\common\build\ufs\8255_mgvm\にtmpフォルダが無ければ作成
if [ ! -d ./out-collect_8255/snapdragon-auto-hqx-4-5-6-0_test_device/common/build/ufs/8255_mgvm/tmp ]; then
    mkdir -p ./out-collect_8255/snapdragon-auto-hqx-4-5-6-0_test_device/common/build/ufs/8255_mgvm/tmp
    echo "tmp directory created."
fi

# out-collect_8255\snapdragon-auto-hqx-4-5-6-0_test_device\common\build\ufs\8255_mgvm\に移動
cd ./out-collect_8255/snapdragon-auto-hqx-4-5-6-0_test_device/common/build/ufs/8255_mgvm

# rawprogram1.xmlがあればtmpフォルダに移動
if [ -f ./rawprogram1.xml ]; then
    mv ./rawprogram1.xml ./tmp/
    echo "rawprogram1.xml moved to tmp directory."
fi

# rawprogram2.xmlがあればtmpフォルダに移動
if [ -f ./rawprogram2.xml ]; then
    mv ./rawprogram2.xml ./tmp/
    echo "rawprogram2.xml moved to tmp directory."
fi

# patch1.xmlがあればtmpフォルダに移動
if [ -f ./patch1.xml ]; then
    mv ./patch1.xml ./tmp/
    echo "patch1.xml moved to tmp directory."
fi

# patch2.xmlがあればtmpフォルダに移動
if [ -f ./patch2.xml ]; then
    mv ./patch2.xml ./tmp/
    echo "patch2.xml moved to tmp directory."
fi

cd $HOME_DIR

# Windowsのホームディレクトリを取得
# /mnt/cから始まる場合はC:に変換し、/homeから始まる場合にはコマンドプロンプトでアクセスできないので終了する
if [[ "$HOME_DIR" == "/mnt/c/"* ]]; then
    # windows配下
    WIN_HOME_DIR=$(echo "$HOME_DIR" | sed 's|^/mnt/c|C:|')
elif [[ "$HOME_DIR" == "/home/"* ]]; then
    # WSL2のUbuntuの場合
    echo "Error: WSL2 is not supported."
    echo "Please run C:"
    exit 1
else
    # その他は不明なので止める
    echo "Error: Unknown HOME_DIR format."
    exit 1
fi

# Windowsのホームディレクトリを表示
echo "WIN_HOME_DIR: $WIN_HOME_DIR"

# Windowsの作業ディレクトリに変換
WIN_WORK_DIR=$(echo "$WIN_HOME_DIR" | sed 's/\//\\/g')
echo "WIN_WORK_DIR: $WIN_WORK_DIR"

# partitionのパス指定用
RAWPROG_PATH="$WIN_WORK_DIR\out-collect_8255\snapdragon-auto-hqx-4-5-6-0_test_device\common\build\ufs\8255_mgvm"
PATCHPROG_PATH="$WIN_WORK_DIR\out-collect_8255\snapdragon-auto-hqx-4-5-6-0_test_device\common\build\ufs\8255_mgvm"

# main domain flashing
echo "========================================"
echo "main domain flashing"
echo "========================================"
cmd.exe /C "pcat -plugin sd -device $VUP_DEVICE -deviceprog $WIN_WORK_DIR\out-collect_8255\snapdragon-auto-hqx-4-5-6-0_test_device\boot\BIN_LeMans_AU\boot_images\boot\QcomPkg\SocPkg\LeMans\Bin\AU\RELEASE\prog_firehose_ddr.elf -build $WIN_WORK_DIR\out-collect_8255\snapdragon-auto-hqx-4-5-6-0_test_device\contents.xml -memorytype ufs -flavor 8255_mgvm -RAWPROG $RAWPROG_PATH\rawprogram0.xml;$RAWPROG_PATH\rawprogram4.xml;$RAWPROG_PATH\rawprogram5.xml;$RAWPROG_PATH\rawprogram6.xml -PATCHPROG $PATCHPROG_PATH\patch0.xml;$PATCHPROG_PATH\patch4.xml;$PATCHPROG_PATH\patch5.xml;$PATCHPROG_PATH\patch6.xml"

echo "========================================"
echo "VUP is completed."
echo "========================================"
