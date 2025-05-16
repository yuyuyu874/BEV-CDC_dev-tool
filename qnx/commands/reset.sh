#!/bin/bash

# 実機を再起動
echo "[LOGS] reset コマンドを実行します。"
"$dir_teraterm/ttpmacro.exe" /I reset.ttl $port

sleep 1
echo "[LOGS] reset コマンドを実行しました。"

echo "[LOGS] デバイスの再起動完了を待機します。"

# タイムアウト時間（秒）
timeout=30

# 開始時間を記録
start_time=$(date +%s)

while true; do
    # adb devicesコマンドの出力を変数に格納
    output=$("$dir_adb/adb.exe" devices)

    # 出力にデバイスが含まれているか確認
    if echo "$output" | grep -q $device_num; then
        echo "デバイスが接続されました。"
        break
    else
        echo -n "・"
    fi

    # 現在の時間を取得
    current_time=$(date +%s)

    # 経過時間を計算
    elapsed_time=$((current_time - start_time))

    # 経過時間がタイムアウト時間を超えたか確認
    if [ $elapsed_time -ge $timeout ]; then
        echo "タイムアウトしました(30秒)。デバイスが接続されませんでした。"
        break
    fi

    # 1秒待機
    sleep 1
done
