#!/bin/sh
## 存放motd檔的地方
MOTD_FILE="${HOME}/.motd"

## 要安裝的shell
TARGET_SHELL="zsh bash"

## 設定取代範圍
CONSOLE_W=80
CONSOLE_L=24

hint_USAGE="使用方式：$0 <ASCII ART TXT> [ ASCII前面要加入幾個空白行 ]"

if [ ! -f "$1"  ]||[ "$1" == ""  ] ;then
	echo "檔案不存在"
	echo "$hint_USAGE"
	exit -1
fi

if [ "$2" == "" ];then
	move_line="0";
	#echo "請指定你要把圖片往後挪幾行"
	#echo "$hint_USAGE"
	#exit -1
else
	move_line=$2;
fi


if [ "$3" == "-r" ]; then
	STEP=-1
	LINE_SEQ=`seq 1 $CONSOLE_L`
else
	STEP=1
	LINE_SEQ=`seq $CONSOLE_L -1 1`
fi

## copy File
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
display_script="cat $MOTD_FILE"
for shell in $TARGET_SHELL;do
	if cat ~/.${shell}rc | grep "$display_script" >> /dev/null ; then
		echo "${shell}已經安裝過了，只更新圖檔"
	else
		echo "正在把motd加入使用者bashrc"
		echo "$display_script" >> ~/.${shell}rc
	fi
done

echo ===========================================
echo ASCII ART motd已經安裝完成
echo 如果需要移除，請刪除 ${MOTD_FILE}與
for shell in $TARGET_SHELL;do
	echo ${HOME}/.${shell}rc
done
echo 中的 \"${display_script}\"這行
echo ===========================================
echo 但是說真的，你捨得嘛？
