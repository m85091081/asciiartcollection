#!/bin/sh

JSON_SRC="https://m85091081.github.io/asciiartcollection/json/list.json"
THEME_SRC="https://m85091081.github.io/asciiartcollection/media/"
INSTALLER_SRC="https://raw.githubusercontent.com/m85091081/asciiartcollection/shell-script/scripts/ASCIIArtInstaller.sh"

WORKING_DIR="$HOME/.asciiarting"
THEME_LIST="$WORKING_DIR/list.txt"
THEME_FOLD="$WORKING_DIR/theme"

function showFileSpLine() {
	cat $1 | sed -n "${2},${2}p"
}

## 建立工作目錄
test -d $WORKING_DIR || mkdir $WORKING_DIR
test -d $THEME_FOLD || mkdir $THEME_FOLD

## 取得清單
list=`curl -fsSL $JSON_SRC | sed "s/,/\n/g" | sed "s/.*\[\"//g" | sed "s/\"\].*//g"`

count=0

## 把清單洗掉
echo -n "" > "$THEME_LIST"

## 整理清單
for theme in $list;
do
	(( count ++ ))
	echo $theme	>> "${THEME_LIST}.tmp"
	#sed "1 i$theme" -i "$THEME_LIST"
done
tac ${THEME_LIST}.tmp > $THEME_LIST
rm ${THEME_LIST}.tmp

## 詢問使用者安裝哪個主題
input_theme=false
while [ "$input_theme" == "false" ];do
	## 顯示佈景主題清單
	echo "可以選擇的圖有："
	echo "======================="
	cat "$THEME_LIST" | grep -n ""
	echo "======================="

	## 詢問使用者要安裝的佈景
	read -p "請輸入ASCII ART代號（數字）：" theme_num
	if [[ "$theme_num" =~ ^[0-9]+$ ]];then
		## 尋找主題名稱
		if theme=`showFileSpLine "$THEME_LIST" "$theme_num"`;then
			## 嘗試下載
			if curl -fsSL "${THEME_SRC}/${theme}.txt" -o $THEME_FOLD/${theme}.txt ;then
				clear
				cat $THEME_FOLD/${theme}.txt
				echo "================================================"
				read -p "這個主題如何？可以的話請輸入y或是輸入n重選 ：" yn
				if [ "$yn" == "y" ] || [ "$yn" == "Y" ];then
					input_theme="${theme}.txt"
				fi
			else
				echo "ASCII ART下載失敗，伺服器上找不到這張圖"
			fi
		else
			echo "請輸入1 ~ $count 範圍內的數字"
		fi
	else
		echo "你輸入的不是數字，請重新輸入"
	fi
done

echo "你要安裝的ASCII ART題已經下載至$THEME_FOLD/${input_theme}"
echo "下載安裝程式..."
curl -fsSL $INSTALLER_SRC -o "$WORKING_DIR/ASCIIArtInstaller.sh"
chmod 755 "$WORKING_DIR/ASCIIArtInstaller.sh"

## 詢問使用者安裝方式
input_method=false
while [ "$input_method" == "false" ];do
	## 說明
	echo "有兩種安裝motd的方式："
	echo "===================================================================="
	echo "1. 安裝到/etc/motd"
	echo "安裝到/etc/motd需要root權限，安裝後不會導致你看不到Last Login的資訊"
	echo "但是如果你使用gdm，因為這裡的motd檔案太大太複雜，會讓gdm當掉無法登入"
	echo "===================================================================="
	echo "2. 安裝到~/.motd"
	echo "安裝到~/.motd不需要root權限，但顯示ASCII ART會把Last Login的資訊洗掉"
	echo "如果是要求安全的環境，請斟酌使用"
	echo "===================================================================="
	echo "1. 安裝到/etc/motd"
	echo "2. 安裝到~/.motd"
	read -p "請選擇：" method
	if [ "$method" == "1" ];then
		input_method="system"
	elif [ "$method" == "2" ];then
		input_method="user"
	else
		input_method=false
		echo "請重新輸入安裝方式！！"
	fi
done


## 詢問使用者要不要留空行惡搞
input_headBlankLine=false
while [ "$input_headBlankLine" == "false" ];do
	## 說明
	echo "前面提到了，顯示這裡的motd會把整個畫面洗掉，所以如果要在ASCII ART前顯示文字"
	echo "也會被洗掉。 如果ASCII ART後顯示文字則是直接插入就好，請輸入0。"
	read -p "有需要ASCII ART前面需要幾行空白行？不需要請輸入0：" input_headBlankLine
	if ! [[ "$input_headBlankLine" =~ ^[0-9]+$ ]];then
		echo "不需要空行也請輸入0"
		input_headBlankLine=false
	fi
done

## 詢問完成
echo "稍後會使用 $EDITOR 編輯motd，你可以加入你需要的內容、或是刪掉內容。"
read -p "按下Enter開始"
bash "$WORKING_DIR/ASCIIArtInstaller.sh" "$THEME_FOLD/$input_theme" $input_headBlankLine $input_method -s
