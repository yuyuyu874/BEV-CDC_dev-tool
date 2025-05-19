# BEV-CDC_dev-tool
## 概要
BEV-CDC開発汎用ツール。
WSLのTerminalからの書込み、シェルへの接続などをサポートします。

## Version 履歴
| Version | 日時 | 説明 |
|-|-|-|
| v1.0 | 2025/5/16 | 初回リリース |

## 機能一覧
### - fastboot
fastbootによって実機にソフトを書き込む為のインタフェースを提供します。
| コマンド | 説明 |
|-|-|
[lv](#-lv) | 

#### * lv
### - pcat

PCATアプリから実機にソフトを書き込むためのインタフェースを提供します。
※森数さん提供のスクリプトを使わせてもらっています。

| コマンド | 説明 |
|-|-|
| [list](#-list) | https://art.geniie.net/artifactory/bevs3cdc-generic-tier1/devops/dn-cdc-soc-26bev-repo/release/ からリリースされているSoCバージョンファイルの一覧を取得します。|
| [get](#-get) | コマンドで指定したSoCバージョンファイルをPCにダウンロードします。
| [all](#-all) | PCATですべてのSoCドメインのflashを行います。https://wiki.geniie.net/pages/viewpage.action?pageId=2860637513
| [main](#-main) | PCATでSoCのメインドメインのflashを行います。https://wiki.geniie.net/pages/viewpage.action?pageId=2860637466
| [sail](#-sail) | PCATでSoCのSAILドメインのflashを行います

#### * list

```bash
$ pcat list
```
WSLにJFコマンドがインストールされてない場合、自動的にJFコマンドのインストールおよび、認証が開始します。完了後にもう一度コマンドを実行してください。

#### * get

```bash
$ pcat get <repo_path>
```
`<repo_path>`には、`pcat list`によって出力された一覧のうちからコピーして指定するようにしてください。

![pcat_get.png](/images/pcat_get.png)

WSLにJFコマンドがインストールされてない場合、自動的にJFコマンドのインストールおよび、認証が開始します。完了後にもう一度コマンドを実行してください。ファイルは work ディレクトリに解凍された状態で格納されます。圧縮ファイル（*.tar.gz）は自動的に削除されます。

#### * all
```bash
$ pcat all
```
https://wiki.geniie.net/pages/viewpage.action?pageId=2860637513 に記載の手順での書込みを行います。

#### * main
```bash
$ pcat main
```
https://wiki.geniie.net/pages/viewpage.action?pageId=2860637466 に記載の手順での書き込みを行います。

#### * sail
```bash
$ pcat sail
```
PCATを用いてSAILドメインの書込みを行います。

### -qnx
TeraTermを用いたQNX Terminalへの接続に関するインタフェースを提供します。

| コマンド | 説明 |
|-|-|
[shell](#-shell) | TeraTermアプリを起動して、QNX Terminal に接続します
[reset](#-reset) | resetコマンドを実行し、実機の再起動を行います
[push](#-push) | コマンドラインで指定したファイルを QNX Terminal の `/mnt/usr/bin/` へpushします

#### * shell
```bash
$ qnx shell
```
TeraTermアプリを起動して、QNX Terminal に接続します。
#### * reset
```bash
$ qnx reset
```
QNX Terminalに接続したのちresetコマンドを実行し、実機の再起動を行います。30秒たってもデバイスとの接続が認められない場合、自動的にタイムアウトします。
#### * push
```bash
$ qnx push <file_path>
```
コマンドラインで指定したファイルを QNX Terminal の `/mnt/usr/bin/` へpushします。pushには以下の方法をとっています。
1. `adb push` で LV の `/firmware/verinfo/` へファイルを転送
1. `reset`コマンドで実機の再起動
1. QNX Terminal に接続し `/firmware/verinfo/` から `/mnt/usr/bin/` へコピー

処理後は、`/firmware/verinfo/` 内の該当ファイルは消去しています


TODO: 現在相対パスでの指定にしか対応していません

## セットアップ方法
### 1. 前準備

### 2. config.sh の設定
各自の環境に依って、config.sh を編集してください。基本的にwindowsのドライブのパスを入力しますが、このときに WSL が認識できる `mnt/c/` から始まるパスを入力するようにしてください。また、作業用のディレクトリは必ず、windowsのドライブ内で作成するようにしてください。（PCATの動作保証がないため）

1. port：TeraTermでQNXと接続しているときのport番号

    ![qnx_terminal.png](/images/qnx_terminal.png)


    上記の場合は、`port=22` と設定する


1. dir_teraterm：TeraTermの .exe ファイルがあるディレクトリ


    ```bash
    dir_teraterm="/mnt/c/Program Files (x86)/teraterm"

     # ディレクトリ名はダブルクォートで囲む
     # WSLでのディレクトリ名を用いる
    ```

1. dir_adb：adb.exe および fastboot.exe があるディレクトリ

    ```bash
    dir_adb="/mnt/c/Program Files/platform-tools"

     # ディレクトリ名はダブルクォートで囲む
     # WSLでのディレクトリ名を用いる
    ```

1. device_num：adb devices で表示されるデバイスのシリアル番号

    ![adb_devices.png](/images/adb_devices.png)

  
    上記の場合は、`device_num=007f0101` と設定する

1. work_dir：書込み用ファイルを格納するための作業用ディレクトリ

    ```bash
    work_dir="/mnt/c/work"

     # ディレクトリ名はダブルクォートで囲む
     # WSLでのディレクトリ名を用いる
     # 必ず、windowsのドライブを指定してください。
    ```

1. dir_pcat：# PCATのパスを指定
    ```bash
    dir_pcat="/mnt/c/Program Files (x86)/Qualcomm/PCAT/bin/PCAT.exe"

     # ディレクトリ名はダブルクォートで囲む
     # WSLでのディレクトリ名を用いる
    ```
### 3. setup.sh の実行


    
    
