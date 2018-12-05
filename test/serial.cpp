#include <cstdio>
#include <cstdlib>
#include <winsock.h>
#include <windows.h>
#include <string.h>
#include <cstring>
#include <conio.h>
#include <iostream>
using namespace std;

#pragma comment(lib, "ws2_32.lib")

HANDLE com = INVALID_HANDLE_VALUE;
char com_name[] = "COM0";

struct Tconsole
{
	Tconsole(){
	    work_com(3);
	}
	void work_com(int );
	void run(HANDLE& com);
};

void Tconsole::work_com(int com_num)
{
	com_name[3] = '0' + com_num;
	DCB dcb;
	com = CreateFileA(com_name,GENERIC_READ|GENERIC_WRITE,0,NULL,OPEN_EXISTING,0,NULL);
	if (com == INVALID_HANDLE_VALUE)
	{
		printf("\n   Can not open %s\n",com_name);
		return ;
	}
	GetCommState(com,&dcb);
	dcb.BaudRate = 9600;
	dcb.ByteSize = 8;
	dcb.StopBits = ONESTOPBIT;
	SetCommState(com,&dcb);
	dcb.ByteSize = 8;
	dcb.Parity = ODDPARITY;
	dcb.StopBits = ONESTOPBIT;
	dcb.fBinary = TRUE;
	dcb.fParity = FALSE;
	SetCommState(com,&dcb);

	printf("\n   Ok..  Connected with com...\n");

	int flag = 0;
	if (com == INVALID_HANDLE_VALUE){
		printf("  COM lost...\n");
		return;
	}
    run(com);
	flag = 1;
	return;
}

void Tconsole::run(HANDLE& com) {
	char ch;
	DWORD size;
	int cnt = 0;
	int num = 0;
	char chararray[10000];

	while(scanf("%d", &num)!= EOF){
		chararray[cnt ++ ] = char(num);
		//printf("num: %d\n", num);
	}
    // printf("cnt : %d\n", cnt);
	WriteFile(com, chararray, cnt, &size, NULL);
	// for(int i = 0; i < cnt; i ++){
	// }
	// ch = 0x90;
	// size = 0;
    // WriteFile(com, &ch, 1, &size, NULL);
	// ch = 0x40;
	// size = 0;
    // WriteFile(com, &ch, 1, &size, NULL);
}
int main() {
	Tconsole console;
	return 0;
}
