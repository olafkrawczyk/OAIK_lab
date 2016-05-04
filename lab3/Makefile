lab3: lab3.c as_Scf.s as_Prft.s prtf_c scf_c
	gcc -g -o lab3 as_Scf.s as_Prft.s lab3.c

prtf_c: printf_lab3.s
	gcc -g -o prtf_c printf_lab3.s

scf_c: scanf_lab3.s
	gcc -g -o scf_c scanf_lab3.s

test: lab3
	@echo "test: "
	echo '1\n2\n3\n' | ./lab3
clean:
	@echo 'Cleaning mess.....'
	rm lab3 prtf_c scf_c
