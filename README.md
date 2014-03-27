Compiler - Simple Scanner in lex
==============

Author
--------------
0016302 楊翔宇

Instructor
-------------
Prof. Yi-Ping You 

Platform
------------
- Operating System: Ubuntu 12.04.4 LTS (Linux ubuntu-vm 3.8.0-29-generic #42~precise1-Ubuntu)
- GCC: gcc version 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5)
- lex: lex 2.5.35

Manual
------------
Basically, I’ve finished the requirements of this project, and they are listed below:

**Tokens that will be passed to the parser**
scan           | how
-------------- | -----------------------
Delimiters | , ; : ( ) [ ]
Arithmetic, Relational, and Logical Operators | + - * / mod := < <= <> >= > and or not
Keywords | array begin boolean def do else end false for integer if of print read real string then to true return var while
Identifiers | {L}({L}|{D})\*
Integer Constants | 0|[1-9]{D}\*, 0{O}+ where O = [0-7]
Floating-Point Constants | (0?|[1-9]{D}\*)(\\.{D}\*)
Scientific Notations | (0?|[1-9]{D}\*)(\\.{D}\*)?[eE][-+]?({D}\*)
String Constants | \"([^\"]|(\"\"))\*\"

**Tokens That Will Be Discarded**
scan           | how
-------------- | -----------------------
Whitespace     | <space> \t \n \r\n
Comments       | // /\* \*/
Pseudocomments | //&S+ //&S- //&T+ //&T-

**Others**
- Error Handle
- Custom String Refination (function removeDoubleQuote in C)

Run
------------
**Run Single Test File**
    >> make
    >> ./scanner <test file>

**Run a List of Test File**
    >> make
    >> vim test.sh ### add the paths in $FILES
    >> ./test.sh

