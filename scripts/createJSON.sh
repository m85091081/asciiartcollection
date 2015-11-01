#!/bin/sh
## 以下路徑都是相對於本Scipt的 ** 工作目錄的 **

# 設定txt與png存放路徑
MEDIA_FOLD="../media"
# 設定JSON檔存放的路徑
OUT_JSON_FOLD="../json/"
# 輸出的包含主列表的JSON檔名
OUT_JSON="list.json"

header="";
script_locate="`pwd`";

json_FULLPATH="${script_locate}/${OUT_JSON_FOLD}/${OUT_JSON}"


cd ${MEDIA_FOLD}
for file in `ls *.txt`;do
	if [ "$header" == "" ]; then
		rm "${json_FULLPATH}"
		echo -n "[" >> "${json_FULLPATH}"
	fi
	
	mainFileName=`echo ${file} | sed s/\.txt//g`
	echo -n ${header}'"'${mainFileName}'"' >> "${json_FULLPATH}"

	header=","
done

echo -n "]" >> "${json_FULLPATH}"
