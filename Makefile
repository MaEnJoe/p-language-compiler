CC=gcc
CFLAGS=-lfl

LEX=lex
YACC=yacc

YACC_TEST_DIR=input_yacc

OUTPUT=parser

all: y.tab.c lex.yy.c
	$(CC) lex.yy.c -ll -o scanner   		# get scanner
	$(CC) lex.yy.c y.tab.c -ll -o $(OUTPUT)	# get parser

y.tab.c: parser.y
	$(YACC) -d -v $<

lex.yy.c: lex.l
	$(LEX) $<

run:
	echo "" > result
	-@./$(OUTPUT) $(YACC_TEST_DIR)/decl.p >> result
	-@./$(OUTPUT) $(YACC_TEST_DIR)/err2.p >> result
	-@./$(OUTPUT) $(YACC_TEST_DIR)/err.p >> result
	-@./$(OUTPUT) $(YACC_TEST_DIR)/expr1.p >> result
	-@./$(OUTPUT) $(YACC_TEST_DIR)/statement.p >> result
	-@./$(OUTPUT) $(YACC_TEST_DIR)/test.p >> result

clean:
	@rm lex.yy.c scanner y.tab.* y.output $(OUTPUT) 
