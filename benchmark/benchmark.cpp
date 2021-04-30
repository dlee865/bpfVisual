#include <unistd.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <vector>
#include <thread>

using namespace std;

void threadFunc( int lengthOfLoop, int threadNum ) {
	int randomBuff = rand() % 1000000;
    char buf1[1000000000], buf2[100000000];
    sprintf( buf1, "thread%dtestfile.txt", threadNum );	
    for( int i = 0; i < lengthOfLoop; i++ ) {
		int fd1 = open(buf1, O_WRONLY | O_CREAT | O_TRUNC, 0644);
		sprintf( buf2, "I have written to this file %d times.", i+1 );	
 	  	write(fd1, buf2, randomBuff);
		close(fd1);
    }	
}

int main( int argc, char** argv ) {
    int rc, fd1, fd2, count, totalBytes;
    char buf[100];
    char *ptr;
    vector<char*> v;

    srand (1111982);
    count = 1;
    for( int i = 0; i < 100; i++) {
    	if( count%2 == 0) fd1 = open("systestfile.txt", O_WRONLY | O_CREAT | O_TRUNC, 777);
	else fd2 = open("systestfile.txt", O_WRONLY | O_CREAT | O_TRUNC, 0644);
    	
	if( fd1 < 0 ) {
		perror("r1");
		return 1;
    	}


	int randomNumber = rand() % 50000;

	if(randomNumber > 30000 && v.size() > 0) { delete(v[v.size()-1]); v.pop_back(); }
    	ptr = new char[500];
	if( count%3 == 0 && v.size() > 0 ) { delete(v[v.size()-1]); v.pop_back(); }
	v.push_back(ptr);

	sprintf( buf, "I have written to this file %d times.\n", count );
	for( int j = 0; j < 1000; j++ ) {	
    		if( count%2 == 0) rc = write(fd1, buf, strlen(buf));
		else rc = write(fd2, buf, strlen(buf));
	}
	sleep(1);
	if( count % 2 == 0 ) close(fd1);
	else close(fd2);
	count++;
    }
    
    thread th1(threadFunc, 1000, 1);
    thread th2(threadFunc, 1500, 2);
    thread th3(threadFunc, 1500, 3);
    th1.join();
    th2.join();
    th3.join();

    totalBytes = 500 * v.size();
    sprintf( buf, "There was %d bytes allocated at the end of the program.", totalBytes );	
    fd2 = open("totalMemoryAllcated.txt", O_WRONLY | O_CREAT | O_TRUNC, 0644);
    rc = write(fd2, buf, strlen(buf));

    return 0;
}
