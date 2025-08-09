All: RSA
LIB=RSALib.o
CC=gcc

RSA: RSA.o $(LIB)
	$(CC) $@.o $(LIB) -g -o $@

.s.o: 
	$(CC) $(@:.o=.s) -g -c -o $@

clean:
	rm -f *.o main
