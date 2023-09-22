# -- Projekt: FLP - Varianta termínu - 7. simplify-bkg
# -- Autor: František Horázný
# -- Login: xhoraz02
# -- Rok: 2022



CC=ghc
CFLAGS=-Wall -i src/*.hs
RM=rm -f

all: clean flp21-fun

flp21-fun:
	$(CC) -o flp21-fun $(CFLAGS)

.PHONY: clean, run, test
clean:
	$(RM) -f src/*.hi src/*.o flp21-fun
    
run: all
	./flp21-fun -i ./test/test1.in

runi: all
	./flp21-fun -i ./test/test1.in
	@echo ""
	@echo "očekávání:"
	@cat ./test/test1-i.out
	@echo ""
	./flp21-fun -i ./test/test1.in | diff -sb - ./test/test1-i.out 

run1: all
	./flp21-fun -1 ./test/test1.in
	@echo ""
	@echo "očekávání:"
	@cat ./test/test1-1.out
	@echo ""
	./flp21-fun -1 ./test/test1.in | diff -sb - ./test/test1-1.out 

run2: all
	./flp21-fun -2 ./test/test1.in
	@echo ""
	@echo "očekávání:"
	@cat ./test/test1-2.out
	@echo ""
	./flp21-fun -2 ./test/test1.in | diff -sb - ./test/test1-2.out 
	