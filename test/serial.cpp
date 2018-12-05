#include <cstdio>
#include <cstdlib>
#include <winsock.h>
#include <windows.h>
#include<string.h>
#include <cstring>
#include <conio.h>
#include<iostream>
using namespace std;

#pragma comment(lib, "ws2_32.lib")

HANDLE com = INVALID_HANDLE_VALUE;

struct Tconsole
{
	Tconsole()
	{
    work_com(3);
	}
	void work_com(int );
	void run(SOCKET &client,HANDLE& com,int isSIM);    //A����
};

void Tconsole::work_com(int com_num)
{
	com_name[3] = '0'+com_num;
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
	dcb.Parity = ODDPARITY;//��У��
	dcb.StopBits = ONESTOPBIT;
	dcb.fBinary = TRUE;
	dcb.fParity = FALSE;
	SetCommState(com,&dcb);

	printf("\n   Ok..  Connected with com...\n");

	int flag=0; //��־�Ƿ��Ǹս���kernel
	while (true)
	{
		if (com == INVALID_HANDLE_VALUE)
		{
			printf("  COM lost...\n");
			goto break_loop;
		}
    run(client, com);
		flag=1;
	}
break_loop:
	return ;
}

Tconsole::run(SOCKET &client,HANDLE& com) {
		ch=0x52;
		size=0;
    WriteFile(com,&ch,1,&size,NULL);
}
int main() {
	Tconsole console;
	return 0;
}
