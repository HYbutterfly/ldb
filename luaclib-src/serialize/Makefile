all : serialize.so

linux : serialize.so

serialize.so : charbuffer.c serialize.c
	gcc -Wall -g -o $@ -fPIC --shared $^

serialize : charbuffer.c serialize.c
	gcc -Wall -g -o $@.dll --shared $^ -I/usr/local/include -L/usr/local/bin -llua53