#!/bin/sh
OUT_TXT="list-txt.json"
OUT_PNG="list-png.json"

header="";

for file in `ls *.txt`;do
	if [ "$header" == "" ]; then
		rm $OUT_TXT
		rm $OUT_PNG
	fi

	echo -n ${header}'{'${file}'}' >> $OUT_TXT
	
	pngFile=`echo ${file} | sed s/\.txt/.png/g`
	echo -n ${header}'{'${pngFile}'}' >> $OUT_PNG

	header=","
done

