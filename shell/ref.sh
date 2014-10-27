#!/bin/bash
# Make a -B- note from Zotero report
# Open a.txt will extracted notes in subl
# Replace ^Highlight and ^Note with # Highlight and # Note
# Check with head -n1 a.txt that it looks ok
# gawk '/#/{n++}{print >"out" n ".txt" }' a.txt
# Run ref.sh ∞0014

y=aa
num=$(ls -l out?*.txt| grep ^- | wc -l)
echo $num

for i in $(seq 1 $num)
do
  file=$(ls out$i.txt)
  if [ -n "$file" ]
    then
      end=$(head -n1 $file |awk -F"#" '{print $2}'|tr -d ' ')
      y=$(perl -E 'print ++$ARGV[0]' $y)
      name="$1°$y-$(gdate +%y%m%d)-N-$end.txt"
      mv $file $name
      echo moving $file to $name
    else
      echo file $file does not exist
  fi
done

