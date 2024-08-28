blah: blah.o
	gcc blah.o -o blah

blah.o: blah.c
	gcc -c blah.c -o blah.o

blah.c:
	echo int main() { return 0; } > blah.c

clean:
	rm -f blah blah.o blah.c
