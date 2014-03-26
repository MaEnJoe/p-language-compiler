#!/bin/bash
EXEC="./scanner"
OUTPUT="out.txt"
FILES="public/advanced/string
public/digit/float
public/general/general_2
public/basic/keyword
public/error_case/error
public/basic/delim
public/digit/integer
public/basic/op
public/general/general_1
public/basic/identifier
public/digit/scientific"

COUNT=0

rm -f $OUTPUT
for f in $FILES
do
    $EXEC $f > /tmp/t
    diff /tmp/t $f"_ans" >> $OUTPUT
    echo "---file:"$f" ends here" >> $OUTPUT
    COUNT=$((COUNT+1))
done

lines=`wc -l $OUTPUT | cut -f1 -d' '`
echo "output save in "$OUTPUT

if [ $lines == $COUNT ]; then
    echo "Pass!"
else
    echo "Failed!"
fi
