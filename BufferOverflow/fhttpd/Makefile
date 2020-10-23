project: webserver

# note that the Makefile must specifically include code to make the stack vulnerable,
# including -fno-stack-protector and -z execstack.
# also, ASLR has been turned off on the server. 

webserver: webserver.c
	gcc -D_FORTIFY_SOURCE=0 -frecord-gcc-switches -fno-stack-protector -z execstack -g -o webserver -D_TS_ERRNO webserver.c -lnsl -lresolv -lpthread
clean: 
	rm webserver *~
