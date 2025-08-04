All: main
LIB=RSALib.o
CC=gcc

main_isPositive: main_isPositive.o $(LIB)
	$(CC) $@.o $(LIB) -g -o $@

.s.o: 
	$(CC) $(@:.o=.s) -g -c -o $@

