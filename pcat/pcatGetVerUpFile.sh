#!/bin/bash
cd $work_dir
set -e

# 引数が空か確認
if [ -z "$1" ]; then
    echo "Error: No argument provided."
    echo "Usage: $0 <file_path>"
    echo "to get file path, please run pcat_getVerList.sh"
    echo "Example: $0 /main/20250410-B00JBSFA001-001/out-collect_8255.tar.gz"
    exit 1
fi

# 定数定義
ARTIFACTORY_URL="https://art.geniie.net/artifactory"
REPO_PATH_VER="bevs3cdc-generic-tier1/devops/dn-cdc-soc-26bev-repo/release"
PREFIX_URL="bevs3cdc-generic-tier1/"
GENNIE_USER=""
GENNIE_PASS=""

echo "check jf command"
# jfコマンドがなかったらインストール
if ! command -v jf &> /dev/null; then
    echo "Info: jf command not found. Installing..."
    curl -fL https://install-cli.jfrog.io | sh
    # jfコマンドのインストールが成功したか確認
    if ! command -v jf &> /dev/null; then
        echo "Error: jf command installation failed."
        exit 1
    fi
    exit 1
fi

echo "check jf auth"
# jfコマンドの認証が済んでいない場合は認証処理を実行
CHECK_JF_AUTH=$(jf config s)
if [ -z "$CHECK_JF_AUTH" ]; then
    echo "Info: jf command not authenticated. Authenticating..."
    # GENNIE_USERとGENNIE_PASSを入力
    read -p "Enter GENNIE USER: " GENNIE_USER
    read -sp "Enter GENNIE PASS: " GENNIE_PASS
    echo # 改行を追加
    # jfコマンドの認証を実行
    jf config add --interactive=false --artifactory-url=${ARTIFACTORY_URL} --password=${GENNIE_PASS} --user=${GENNIE_USER}
    # jfコマンドの認証が成功したか確認
    CHECK_JF_AUTH=$(jf config s)
    if [ -z "$CHECK_JF_AUTH" ]; then
        echo "Error: jf command authentication failed."
        exit 1
    fi
fi

# 引数として渡されたファイルのパス
SELECTED_FILE=$1
DOWNLOAD_URL="$REPO_PATH_VER$SELECTED_FILE"
# out-collect_8255.tar.gzのダウンロード
jf rt download --flat=false "$REPO_PATH_VER$SELECTED_FILE"
# jfコマンドのダウンロードが成功したか確認
if [ $? -ne 0 ]; then
    echo "Error: jf command download failed."
    exit 1
fi

BASE_PATH=$(dirname "$SELECTED_FILE")
VER_NAME=$(basename "$BASE_PATH")
FILE_NAME=$(basename "$SELECTED_FILE")

echo "Version: $VER_NAME"
touch "$VER_NAME"

COPY_PATH="${DOWNLOAD_URL#"$PREFIX_URL"}"
if [ -z "$COPY_PATH" ]; then
    echo "Error: Invalid file path."
    exit 1
fi
mv "$COPY_PATH" .
rm -rf devops
# out-collect_8255.tar.gzがあれば解凍
if [ -f "$FILE_NAME" ]; then
    echo "Info: $FILE_NAME found. Unzipping..."
    tar -zxvf "$FILE_NAME"
else
    echo "Error: $FILE_NAME not found."
    exit 1
fi

echo "Info: $FILE_NAME unzipped successfully."
# out-collect_8255.tar.gzを削除
rm -f "$FILE_NAME"

echo "Info: $FILE_NAME deleted successfully."
