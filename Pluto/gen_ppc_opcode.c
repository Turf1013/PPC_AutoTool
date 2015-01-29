#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define FILEINNAME "data"   // End of file need an blank line
#define FILEOUTNAME "dout"

#define MAXN 100
#define MAXL 15
#define MAXC 105

char buf[MAXC];
char instr[MAXL][MAXN];
int op[MAXN][2];    // 0:pri, 1:ext

void output(int n);

int main() {
    int i, k, flg;
    int n = 0;
    FILE *fin = NULL;

    fin = fopen(FILEINNAME, "r");

    if (fin == NULL) {
        printf("Can't open %s\n", FILEINNAME);
        return -1;
    }
    memset(op, 0, sizeof(op));
    while (fgets(buf, MAXC, fin) != NULL) {
        printf("buf=%s\n", buf);
        if (buf[0] == '\n')
            continue;
        flg = k = 0;
        for (i=0; buf[i]&&buf[i]!='\n'; ++i) {
            if (buf[i] == ' ') {
                if (flg == 0)
                    instr[n][i] = '\0';
                if (flg == 1) {
                    op[n][flg-1] = k;
                    k = 0;
                }
                ++flg;
                continue;
            }
            if (flg == 0)
                instr[n][i] = buf[i];
            else {
                k = 10*k + buf[i]-'0';
            }
        }
        op[n][flg-1] = k;
        ++n;
    }

    fclose(fin);
    output(n);

    return 0;
}

void output(int n) {
    FILE *fout;
    int i;

    printf("n = %d\n", n);
    fout = fopen(FILEOUTNAME, "w");
    if (fout == NULL) {
        printf("Can't open %s\n", FILEOUTNAME);
        return ;
    }

    fprintf(fout, "char mnemonic[MAXL][MAXN] = {\n");
    for (i=0; i<n; ++i) {
        if (i != n-1)
            fprintf(fout, "\t{\"%s\"},\n", instr[i]);
        else
            fprintf(fout, "\t{\"%s\"}\n", instr[i]);
    }
    fprintf(fout, "};\n\n\n");

    fprintf(fout, "u16 Primary_Op[MAXN] = {\n");
    for (i=0; i<n; ++i) {
        if (i != n-1)
            fprintf(fout, "\t%d,\n", op[i][0]);
        else
            fprintf(fout, "\t%d\n", op[i][0]);
    }
    fprintf(fout, "};\n\n\n");

    fprintf(fout, "u16 Extend_Op[MAXN] = {\n");
    for (i=0; i<n; ++i) {
        if (i != n-1)
            fprintf(fout, "\t%d,\n", op[i][1]);
        else
            fprintf(fout, "\t%d\n", op[i][1]);
    }
    fprintf(fout, "};\n\n\n");

    fflush(fout);
    fclose(fout);
}
