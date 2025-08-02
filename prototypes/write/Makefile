# Program Name: Makefile
# Author:	Brian Astrove
# Date:		Aug 3, 2025
# Purpose:	To assemble and link the  write function

All: main
LIB=write.o
CC=gcc

main: main.o $(LIB)
	$(CC) $@.o $(LIB) -g -o $@

.s.o:
	$(CC) $(@:.o=.s) -g -c -o $@

clean:
	rm -f *.o main
    

