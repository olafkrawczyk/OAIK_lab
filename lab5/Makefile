all:
	@echo "kompilacja:"
	gcc -o lab5 lab5.c calka_fpu.s get_fpu.s set_fpu.s

test: lab5
	@echo "test:"
	./lab5

clean:
	@echo "czyszczenie katalogu:"
	rm lab5
