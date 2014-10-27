#!/bin/bash
#
# call with dina5_book file.pdf
file=$1
filebase=$(basename $file .pdf)
pdftops $file output.ps
psbook output.ps tmp.ps
pstops "4:0L@.7(21cm,0)+1L@.7(21cm,14.85cm),2R@.7(0,29.7cm)+3R@.7(0,14.85cm)" tmp.ps > ${filebase}-booklet.ps
rm -f output.ps tmp.ps
echo "Converting back to pdf ..."
ps2pdf ${filebase}-booklet.ps
rm -f ${filebase}-booklet.ps
