#!/bin/sh

for file in *.html; do
   basefile=`echo $file | sed s/.html//`
   echo "Converting $basefile..."
   ./convert.sh $basefile.html && mv converted.tex $basefile.tex
done
