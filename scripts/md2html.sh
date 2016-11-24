#!/bin/sh

NO_PROCESS_FILE="README\.md "

EXTRA_HEAD='<!DOCTYPE html>
<html><head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="https://stackedit.io/res-min/themes/base.css" />
<script type="text/javascript" src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS_HTML"></script>
</head><body><div class="container">'

EXTRA_FOOTER='</div></body></html>'

fileList=`ls *.md`
for i in $NO_PROCESS_FILE; do
  fileList=`sed "s/$i//g" <<< $fileList`
done


for i in $fileList; do
  inputFile=$i
  outputFile=`sed "s/\.md/\.html/g" <<< $i`

  cat <<< $EXTRA_HEAD > $outputFile
  pandoc $inputFile >> $outputFile
  cat <<< $EXTRA_FOOTER >> $outputFile

done


inputFile="README.md"
outputFile="download.html"

cat <<< $EXTRA_HEAD > $outputFile
pandoc $inputFile >> $outputFile
cat <<< $EXTRA_FOOTER >> $outputFile

