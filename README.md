## 開發者向


### 基本介紹

__警告:__ _ASCII Art Installer 僅供 Unix/-Like環境使用._

* [一般]你需要一個 Linux 或是 Unix-Based/Like 的 OS 。
* [一般]`curl` 必須安裝。
* [一般]如果要安裝到 shell 你需要一個 shell 環境（預設支援bash/zsh）。
* [開發]如果您需要二次開發我們的工具請依照 GNU 授權。
* [開發]本腳本全程使用 Shell Script 進行開發以及使用 git 進行版本控制。
* [所有]你的宅魂（？

### 開發者基礎事項 

* 所有的最新 script 都在 shell-script 分支 的 /script 資料夾內。
* ASCII Art 的 sample 檔 都在 shell-script 分支 的 /media 資料夾。
* 如需要修改可以參考我們的註解進行修改。
* 如果發現了罷個（bug）請幫我們送 PR。
* 前端相關的東西都在 gh-pages 這個分支。
* Master 分支 僅存放 穩定板的 shell-script , 最新的 beta-script 都會在 shell-script分支。
* 最後歡迎跳坑～。

### 下載整個專案

```shell
git clone https://github.com/m85091081/asciiartcollection.git
```

### 最後這個是安裝用的 script 

使用 curl 進行 loader.sh 抓取。
```shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/m85091081/asciiartcollection/shell-script/scripts/loader.sh )"
```


