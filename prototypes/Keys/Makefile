CC = gcc
LIBS = libKeys.o ../GCDMod/libGCDMod.o

all: main

main: main.o $(LIBS)
	$(CC) $@.o $(LIBS) -g -o $@

.s.o:
	$(CC) $(@:.o=.s) -g -c -o $@

clean:
	rm -f *.o ../GCDMod/libGCDMod.o main
