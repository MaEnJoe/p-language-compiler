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

rm -f $OUTPUT
for f in $FILES
do
    $EXEC $f > /tmp/t
    echo "==========================" >> $OUTPUT
    echo "file: "$f >> $OUTPUT
    diff /tmp/t $f"_ans" >> $OUTPUT
done

echo "output save in "$OUTPUT
