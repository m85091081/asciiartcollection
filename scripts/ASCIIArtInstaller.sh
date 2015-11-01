#!/bin/sh
## 設定取代範圍
CONSOLE_W=80
CONSOLE_L=24

function ctl_char_esc() { 
	cat char.txt
}
if [ ! -f "$1"  ]||[ "$1" == ""  ] ;then
	echo "檔案不存在"
	exit -1
fi

if [ "$2" == "" ];then
	echo "請指定你要把圖片往後挪幾行"
	exit -1
fi

if [ "$3" == "-r" ]; then
	STEP=-1
else
	STEP=1
fi

## copy File
cp $1 /tmp/motd

## 調整行
if [ "$2" != "0" ]; then
	for wid in `seq $CONSOLE_W -1 1`;do
		for line in `seq $CONSOLE_L -1 1`;do
			(( new_line = $line + $2 * $STEP ))
			sed -i s/"\[${line};${wid}H"/"[${new_line};${wid}H"/g "/tmp/motd"
			## echo sed -i s/"\[${line};${wid}H"/"[${new_line};${wid}H"/g "/tmp/motd"
			##echo $line $new_line		
		done
	done
fi

## 加入空白行
if [ "$STEP" == 1 ];then
	for line in `seq $2 -1 1`;do
		sed -i "1 i[${line};0m" "/tmp/motd"
	done
fi

read -p "最後修改，加入你需要的內容、或是刪除不需要的內容吧！ 按下Enter開始"
$EDITOR "/tmp/motd"

## 加入自動清除畫面的控制碼
sed -i "1,1s/^/[H[J&/g" "/tmp/motd"

## 安裝
cp /etc/motd /etc/motd-`date +%Y-%m-%d_%H-%M-%S`
cp /tmp/motd /etc/motd
