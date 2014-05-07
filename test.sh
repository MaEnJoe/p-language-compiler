#!/bin/bash
EXEC="./scanner"
OUTPUT="out.txt"
FILES="input_lex/advanced/string
input_lex/digit/float
input_lex/general/general_2
input_lex/basic/keyword
input_lex/error_case/error
input_lex/basic/delim
input_lex/digit/integer
input_lex/basic/op
input_lex/general/general_1
input_lex/basic/identifier
input_lex/digit/scientific"

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
