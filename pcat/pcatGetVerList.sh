#!/bin/bash
cd $work_dir
set -e

# 定数定義
ARTIFACTORY_URL="https://art.geniie.net/artifactory"
REPO_PATH_VER="bevs3cdc-generic-tier1/devops/dn-cdc-soc-26bev-repo/release/"
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

# Check if jq is installed
if ! dpkg-query -W -f='${Status}' jq 2>/dev/null | grep -q "ok installed"; then
    echo "jq is not installed. Installing jq..."
    sudo apt update
    sudo apt install -y jq
else
    echo "jq is already installed."
fi

echo "get list"

# 過去ソフトver一覧取得
TMP_PAST_VER_LISTS=$(curl -s --netrc "$ARTIFACTORY_URL/api/storage/$REPO_PATH_VER?list&deep=1")

echo "=========================="
echo "$TMP_PAST_VER_LISTS" | jq -r '.files[] | select(.uri | endswith(".tar.gz")) | .uri'
echo "=========================="
echo "/main が最新ソフトです"