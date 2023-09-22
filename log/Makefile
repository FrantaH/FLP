# -- Projekt: FLP - Varianta termínu - 4.	Rubikova kostka
# -- Autor: František Horázný
# -- Login: xhoraz02
# -- Rok: 2022


CC=swipl
CFLAGS=--goal=start --stand_alone=true -c ./kostka.pl
RM=rm -f

all: clean flp21-log

flp21-log:
	$(CC) -o flp21-log $(CFLAGS)

.PHONY: clean, run
clean:
	$(RM) -f flp21-log

run: run6

run6: all
	@echo " "
	cat test6.in | time ./flp21-log

run7: all
	@echo " "
	cat test7.in | time ./flp21-log

run8: all
	@echo " "
	cat test8.in | time ./flp21-log

run9: all
	@echo " "
	cat test9.in | time ./flp21-log
