#include <rawapi.h>

unsigned char * 
strncpy(unsigned char *dest, const unsigned char*src, int n)
{
    int i=0;
    unsigned char x;
    while(i < n){
        x = src[i];
        dest[i] = x;
        if(x == 0) break;
        i++;
    }
    return dest;
}

void * memset(void * s, int c, int n)
{
    char * p=s;
    int i;
    for(i=0; i<n; i++){
        p[i] = c;
    }
    return s;
}

int isspace(int c)
{
    if(c=='\f' || c=='\n' || c=='\r' || c=='\t' || c=='\v'){
		return 1;
    } else {
		return 0;
	}
}
