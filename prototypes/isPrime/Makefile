# Program Name: Makefile
# Author:	Brian Astrove
# Date:		July 29, 2025
# Purpose:	To assembly and link the isPrime function

All: main
LIB=isPrime.o
CC=gcc

main: main.o $(LIB)
	$(CC) $@.o $(LIB) -g -o $@

.s.o:
	$(CC) $(@:.o=.s) -g -c -o $@

clean:
	rm -f *.o main
    

