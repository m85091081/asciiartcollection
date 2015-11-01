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

for wid in `seq $CONSOLE_W -1 1`;do
	for line in `seq $CONSOLE_L -1 1`;do
		(( new_line = $line + $2 * $STEP ))
		sed -i s/"\[${line};${wid}H"/"[${new_line};${wid}H"/g "$1"
		## echo sed -i s/"\[${line};${wid}H"/"[${new_line};${wid}H"/g "$1"
		##echo $line $new_line
		
	done
done

if [ "$STEP" == 1 ];then
	for line in `seq $2 -1 1`;do
		sed -i "1 i[${line};0m" "$1"
	done
fi
