all:
	@echo "kompilacja:"
	gcc -o lab5 lab5.c calka_fpu.s get_fpu.s set_fpu.s calka_SIMDd.s calka_SIMDf.s calka_sseD.s calka_sseF.s

test: lab5
	@echo "test:"
	./lab5

noCount: 
	gcc -g -o calka test.c calka_SIMDf.s calka_SIMDd.s calka_sseF.s calka_sseD.s
clean:
	@echo "czyszczenie katalogu:"
	rm lab5 calka
