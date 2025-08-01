CC = gcc
AS = as
TARGETS = test_pow test_modulus
LIB = pow_modulus.o

all: $(TARGETS)

test_pow: test_pow.s $(LIB)
	$(CC) $< $(LIB) -o $@

test_modulus: test_modulus.s $(LIB)
	$(CC) $< $(LIB) -o $@

pow_modulus.o: pow_modulus.s
	$(AS) $< -o $@

clean:
	rm -f *.o $(TARGETS)
