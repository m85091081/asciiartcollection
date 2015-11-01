#!/bin/sh

## 要安裝的shell
TARGET_SHELL="zsh bash"

## 設定取代範圍
CONSOLE_W=80
CONSOLE_L=24

hint_USAGE="使用方式：$0 <ASCII ART TXT> <ASCII前面要加入幾個空白行> <安裝到user或system>"

function install() {
	for shell in $TARGET_SHELL;do
		if cat ~/.${shell}rc | grep "$display_script" >> /dev/null ; then
			echo "${shell}已經安裝過了，只更新圖檔"
		else
			echo "正在把motd加入使用者bashrc"
			echo "$display_script" >> ~/.${shell}rc
		fi
	done
}

if [ $1 == "system-user" ]; then
	MOTD_FILE="/etc/motd"
	display_script="shopt -q login_shell || cat $MOTD_FILE"
	install
	exit 0
	
elif [ ! -f "$1"  ]||[ "$1" == ""  ] ;then
	echo "ASCII ART TXT檔案不存在"
	echo "$hint_USAGE"
	exit -1
fi

if ! [[ "$2" =~ ^[0-9]+$ ]];then
	echo "你輸入的數字錯誤，無視"
	echo "$hint_USAGE"
	exit -1
else
	move_line=$2
fi

if [ "$3" == "system" ];then
	mode="SYS"
	echo "安裝到系統 (/etc/motd)"
	if [ "$USER" != "root" ];then
		echo "安裝到系統需要Root權限！！"
		exit -1
	fi
	echo "安裝到系統不會洗掉原有的No Mail、Last Login提示"
	echo "請注意GDM會讀取/etc/motd，而複雜的ASCII Art會讓GDM掛掉無法登入使用者！！"
	read -p "繼續安裝請按下Enter，取消請按Ctrl C"
	MOTD_FILE="/etc/motd"
	display_script="shopt -q login_shell || cat $MOTD_FILE"
elif [ "$3" == "user" ];then
	mode="USER"
	echo "安裝到使用者 (~/.motd)"
	echo "安裝到使用者root權限，但是會把原本的No Mail、Last Login提示覆蓋掉"
	echo "如果你要確保系統安全，不推薦使用本方式安裝！！"
	read -p "繼續安裝請按下Enter，取消請按Ctrl C"
	MOTD_FILE="${HOME}/.motd"
	display_script="cat $MOTD_FILE"
else
	echo "請選擇安裝到user或system"
	echo "$hint_USAGE"
	exit -1
fi

if [ "$4" == "-r" ]; then
	STEP=-1
	LINE_SEQ=`seq 1 $CONSOLE_L`
else
	STEP=1
	LINE_SEQ=`seq $CONSOLE_L -1 1`
fi

## copy File
mv "$MOTD_FILE" "${MOTD_FILE}-`date +%Y%m%d-%H%M%S`"
cp $1 "$MOTD_FILE"


## 調整行
if [ "$move_line" != "0" ]; then
	for wid in `seq $CONSOLE_W -1 1`;do
		for line in ${LINE_SEQ};do
			(( new_line = $line + $move_line * $STEP ))
			sed -i s/"\[${line};${wid}H"/"[${new_line};${wid}H"/g ""$MOTD_FILE""
			## echo sed -i s/"\[${line};${wid}H"/"[${new_line};${wid}H"/g ""$MOTD_FILE""
			##echo $line $new_line		
		done
	done
fi

## 加入空白行
if [ "$STEP" == 1 ];then
	for line in `seq $move_line -1 1`;do
		sed -i " i[${line};0m" "$MOTD_FILE"
	done
fi

read -p "最後修改，加入你需要的內容、或是刪除不需要的內容吧！ 按下Enter開始"
$EDITOR "$MOTD_FILE"

## 加入自動清除畫面的控制碼
sed -i "1,1s/^/[H[J&/g" "$MOTD_FILE"


## 安裝
install

echo ===========================================
echo ASCII ART motd已經安裝完成
echo 如果需要移除，請刪除 ${MOTD_FILE}與
for shell in $TARGET_SHELL;do
	echo ${HOME}/.${shell}rc
done
echo 中的 \"${display_script}\"這行
if [ $MODE == "SYS" ];then 
	echo 如果其他使用者non-login shell也要看到motd
	echo 請切換使用者後執行 $0 system-user
fi
echo ===========================================
echo "但是說真的，你捨得嘛？"
exit 0

