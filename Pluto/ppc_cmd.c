#include "ppc_cmd.h"
#include "ppc_regs.h"
#include "ppc_mem.h"
#include "ppc_arch.h"
#include "ppc_cu_vdef.h"
#include <stdio.h>
#include <string.h>

#define EXE_MAXN 100
#define CMD_MAXL 55
#define isSpace(ch) (ch==' '||ch=='\t')
#define isNum(ch)   (ch>='0'&&ch<='9')

static char cmd[CMD_MAXL], para[CMD_MAXL];
static u32 exe_time;
static u32 default_PC, default_IM, default_DM, default_GPR[PPC_GPR_N];

void initial_cmd() {
	default_PC = default_IM = default_DM = 0;
	memset(default_GPR, 0, sizeof(default_GPR));
}

static void Invalid_cmd() {
    printf("Invalid CMD.\n");
}

void which_cmd(char str[], int l) {
    if (l == 1) {
        switch (str[0]) {
            case 'p':
                cmd_print();
                break;

            case 'e':
                cmd_execute();
                break;

            case 'r':
                cmd_restart();
                break;

            case 'l':
                cmd_link();
                break;

            case 'd':
                cmd_dump();
                break;

            case 'c':
                cmd_configure();
                break;

            case 'q':
                cmd_quit();
                break;

            default:
                Invalid_cmd();
                return ;
        }
    } else {
        if (strcmp(str, "print") == 0) {
            cmd_print();
        } else if (strcmp(str, "execute") == 0) {
            cmd_execute();
        } else if (strcmp(str, "restart") == 0) {
            cmd_restart();
        } else if (strcmp(str, "link") == 0) {
            cmd_link();
        } else if (strcmp(str, "dump") == 0) {
            cmd_dump();
        } else if (strcmp(str, "configure") == 0) {
            cmd_configure();
        } else if (strcmp(str, "quit") == 0) {
            cmd_quit();
        } else {
            Invalid_cmd();
        }
    }
}

void pluto_cmd() {
    char str[CMD_MAXL];
    int i, l;

    while (1) {
        gets(cmd);
        if (cmd[0] == '\0')
            continue;
        i = l = 0;
        while ( isSpace(cmd[i]) )
            ++i;
        while ( !isSpace(cmd[i]) )
            str[l++] = cmd[i++];
        str[l] = '\0';
        strcpy(para, cmd+i);
        which_cmd(str, l);
    }
}
/*
 * 1. p(rint) [-rmid]: print
 *   parameter:
 *      -r [*a*] [*b*]: regs from rA to rB
 *      -i [*a*] [*b*]: imem from addrA to addrB
 *      -d [*a*] [*b*]: imem from addrA to addrB
 */
static void cmd_print_default(int from[], int to[]) {
    /* GPR */
    from[0] = 0; to[0] = 32;
    /* IMEM */
    from[1] = 0; to[1] = 0x40;
    /* DMEM */
    from[2] = 0; to[2] = 0x20;
}

static int try_getNum(char str[], int *x) {
    int i = 0;
    int val = 0;
    while ( isSpace(str[i]) )
        ++i;
    if ( !isNum(str[i]) )
        return 0;
    while ( isNum(str[i]) ) {
        val = 10*val + str[i]-'0';
        ++i;
    }
    *x = val;
    return i;
}

static void print_regs(int from, int to) {
    int i, j, k;
    if (from<0 || to>=PPC_GPR_N || from>=to) {
        Invalid_cmd();
        return ;
    }
    for (j=0,i=from; i<to; ++i,++j) {
        if (j & 3 == 0) {
            printf("\n");
            k = i+3;
            if (k >= PPC_GPR_N)
                k = PPC_GPR_N - 1;
            printf("r%d-r%d:\t", i, k);
        }
        printf("%08x\t", regs_get_GPR(i));
    }
}


static void print_imem(int from, int to) {
    int i, j;
    if (from<0 || to>=PPC_IMEM_SIZE || from>=to) {
        Invalid_cmd();
        return ;
    }
    for (j=0,i=from; i<to; i+=4,++j) {
        if (j & 3 == 0) {
            printf("\n");
            k = i+12;
            if (k >= (PPC_IMEM_SIZE<<2))
                k = (PPC_IMEM_SIZE<<2) - 4;
            printf("[%08x]-[%08x]:\t", i, k);
        }
        printf("%08x\t", get_imem(i>>2));
    }
}

static void print_dmem(int from, int to) {
    int i, j;
    if (from<0 || to>=PPC_DMEM_SIZE || from>=to) {
        Invalid_cmd();
        return ;
    }
    for (j=0,i=from; i<to; i+=4,++j) {
        if (j & 3 == 0) {
            printf("\n");
            k = i+12;
            if (k >= (PPC_DMEM_SIZE<<2))
                k = (PPC_DMEM_SIZE<<2) - 4;
            printf("[%08x]-[%08x]:\t", i, k);
        }
        printf("%08x\t", get_dmem(i>>2, DMOp_LWZ));
    }
}

static void print_help() {
	printf("\n\t*****  p(rint)  *****\n");
	printf("parameter:\n");
	printf("\t-r [*a*] [*b*]: regs from rA to rB;\n");
	printf("\t-i [*a*] [*b*]: imem from addrA to addrB;\n");
	printf("\t-d [*a*] [*b*]: imem from addrA to addrB.\n");
}

void cmd_print() {
    int a[3], b[3];
    int i, j=0, flg = 0, k, tmp;

    cmd_print_default(a, b);
    i = j = 0;
    while (para[i]) {
        if ( isSpace(para[i]) ) {
            ++i;
            continue;
        }
        if (flg == 0) {
            if (para[i] == '-') {
                flg = 1;
				if (para[i+1] == 'h') {
					j =8
					break;
				}
            } else {
                Invalid_cmd();
                return ;
            }
        } else if (flg == 1) {
            switch (para[i]) {
            case 'r':
                flg = 2;
                j |= 1;
                k = 0;
                break;
            case 'i':
                flg = 2;
                j |= 2;
                k = 1;
                break;
            case 'd':
                flg = 2;
                j |= 4;
                k = 2;
                break;
            default:
                Invalid_cmd();
                return ;
            }
        } else if (flg == 2) {
            if ( isNum(para[i]) ) {
                tmp = try_get_Num(para+i, &a[k]);
                if (tmp) {
                    i += tmp;
                    tmp = try_get_Num(para+i, &b[k]);
                    if (tmp)
                        i += tmp;
                    else
                        b[k] = a[k]+1;
                } else {
                    printf("Never happen.\n");
                }
                continue;
            }
            switch (para[i]) {
            case 'r':
                j |= 1;
                k = 0;
                break;
            case 'i':
                j |= 2;
                k = 1;
                break;
            case 'd':
                j |= 4;
                k = 2;
                break;
            default:
                Invalid_cmd();
                return ;
            }
        }
        ++i;
    }
    if (j & 1)
        print_regs(a[0], b[0]);
    if (j & 2)
        print_imem(a[1], b[1]);
    if (j & 4)
        print_dmem(a[2], b[2]);
	if (j & 8)	
		print_help();
}

/*
 * 2. e(xecute) [-nar]: Execute
 *   parameter:
 *      [-n]: Execute next instruction
 *      [-a]: Execute All instruction
 *      [-r]: ReExecute last instruction
 */
static void execute_help() {
	printf("\n\t*****  e(xecute)  *****\n");
	printf("parameter:\n");
	printf("\t[-n][=XXX]: Execute next XXX instruction;\n");
	printf("\t[-a]: Execute All instruction;\n");
	printf("\t[-r]: ReExecute last instruction;\n");
}

static void execute_restart() {
	u32 i;
	// initial PC/GPR/Memory
	initial_pc(default_PC);
	initial_imem(default_IM);
	initial_dmem(default_DM);
	for (i=0; i<PPC_GPR_N; ++i)
		regs_set_GPR(i, default_GPR[i]);
	
	// initial the modules
	cu_initial();	
	ALU_initial();
	
	// initial the exe_time
	exe_time = 0;
}

static void execute_one() {
	u32 instr, pc;
	cu_work();
	instr = cu_get_instr();
	pc = cu_get_pc();
	printf("[%08x]: %08x\n", pc, instr);
	++exe_time;
}

static void execute_next(u32 ntime) {
	int i;
	
	for (i=0; i<ntime; ++i) {
		execute_one();
	}
}

static void execute_all() {
	execute_next(EXE_MAXN);
}

static void execute_last() {
	u32 ntime = exe_time;

	execute_restart();
	execute_next(ntime);
}
 
void cmd_execute() {
	int i, k, ntime=1;
	
	i = k = 0;
	while ( isSpace(para[i]) )
		++i;
	if (para[i] == '-') {
		switch (para[i+1]) {
			case 'n':
				k = 1;
				if (para[i+2] == '=') {
					try_getNum(para+i+3, &ntime);
				}
				break;
			case 'a':
				k = 2;
				break;
			case 'r':
				k = 4;
				break;
			case 'h':
				k = 8;
				break;
			default:
				Invalid_cmd();
				return ;	
		}
	} else {
		Invalid_cmd();
		return ;
	}
	if (k & 1)
		execute_next(ntime);
	if (k & 2)
		execute_all();
	if (k & 4)	
		execute_last();
	if (k & 8)
		execute_help();
}

/*
 * r(estart): Restart
 */
void cmd_restart() {
	int i, k;
	i = k = 0;
	while ( isSpace(para[i]) )
		++i;
	if (para[i]=='-' && para[i+1]=='h') {
		printf("NO Parameter.\n");
		return ;
	}
	if (para[i] != '\0')
		Invalid_cmd();
	else	
		execute_resatrt();
}

/*
 *l(ink): [-abs] filename: Link file as BIN
 *   parameter:
 *      [-a]: Link ASCII File
 *      [-b]: Link Binary File
 *      [-s]: Link .asm File
 */
static void Invalid_link(char path[]) {
	printf("Invali Link File: %s\n", path);
}

static void link_help() {
	printf("\n\t*****  l(ink)  *****\n");
	printf("parameter:\n");
	printf("\t[-a]: Link ASCII File;\n");
	printf("\t[-b]: Link Binary File;\n");
	printf("\t[-s]: Link .asm File;\n");
}

static link_ascii(char path[]) {
	u32 val, addr;
	FILE *fin = fopen(path, "r");
	if (fin == NULL) {
		Invalid_link(path);
		return ;
	}
	addr = PPC_IMEM_BASE;
	while (fscanf(fin, "%x", &val) != EOF) {
		set_imem(addr, x);
		addr += 4;
	}
	fclose(fin);
}

static link_binary(char path[]) {
	u32 vals[100], addr;
	int i, n;
	
	FILE *fin = fopen(path, "rb");
	if (fin == NULL) {
		Invalid_link(path);
		return ;
	}
	addr = PPC_IMEM_BASE;
	while ( !feof(fin) ) {
		n = fread(vals, sizeof(unsigned int), 100, fin);
		for (i=0; i<n; ++i) {
			set_imem(addr, vals[i]);
			addr += 4;
		}
	}
	fclose(fin);
}

void cmd_link() {
	int i, j, k=0;
	char path[CMD_MAXL];
	
	/* No checking th valid of FILE. */
	while ( isSpace(para[i]) )
		++i;
	if (para[i] == '-') {
		switch (para[i+1]) {
			case 'a':
				k = 1;
				break;
				
			case 'b':
				k = 2;
				break;
				
			case 's':
				k = 4;
				break;
				
			case 'h':
				k = 8;
				break;
				
			default:
				Invalid_cmd();
				return ;
		}
	} else {
		Invalid_cmd();
		return ;
	}
	while ( isSpace(para[i]) )
		++i;
	if (para[i] != '\0') {
		strcpy(path, para+i);
	} else {
		Invalid_cmd();
		return ;
	}
	if (k & 1)
		link_ascii(path);
	if (k & 2)
		link_binary(path);
	if (k & 4) {
		/* NOT Supported */
		printf("Link .asm NOT Supported.")
	}
	if (k & 8)
		link_help();
}

/*
 * 5. d(ump) [-mx]: dump BIN File
 *		[-m]: dump hex File used by Modelsim
 *		[-x]: dump hex FIle used by Xilinx
 */
void cmd_dump() {
	printf("Not supported.\n");
}

/*
 * 6. c(onfigure): configure
 *      [-pc=XXX]: inital_PC = XXX;
 *      [-im=XXX]: inital_IM = XXX;
 *      [-dm=XXX]: inital_DM = XXX;
 *      [-rX=XXX]: GPR[X] = XXX;
 */
static configure_help() {
	printf("\n\t*****  c(onfigure)  *****\n");
	printf("parameter:\n");
	printf("\t[-pc=XXX]: inital_PC = XXX;\n");
	printf("\t[-im=XXX]: inital_IM = XXX;\n");
	printf("\t[-dm=XXX]: inital_DM = XXX;\n");
	printf("\t[-rX=XXX]: GPR[X] = XXX;\n");
}

void cmd_configure() {
	int i, j, val, k=0, rn=0;
	
	while (para[i]) {
		if (isSpace(para[i])) {
			++i;
			continue;
		}
	}
	if (para[i] == '-') {
		if (para[i+1]=='p' && para[i+2]=='c' && para[i+3] == '=') {
			k = 1;
		} else if (para[i+1]=='i' && para[i+2]=='m' && para[i+3] == '=') {
			k = 2;
		} else if (para[i+1]=='d' && para[i+2]=='m' && para[i+3] == '=') {
			k = 4;	
		} else if (para[i+1]=='r') {
			k = 8;
			if ( isNum(para[i+2]) ) {
				rn = para[i+2] - '0';
			} else {
				Invalid_cmd();
				return ;
			}
			if ( isNum(para[i+3]) && para[i+4]=='=' ) {
				rn = 10*rn + para[i+3]-'0';
				++i;
			} else if (para[i+3] == '=') {
				/* do nothing. */
			} else {
				Invalid_cmd();
				return ;
			}
		} else if (para[i+1]=='h') {
			k = 16;
		} else {
			Invalid_cmd();
			return ;
		}
		if (para[i+1] != 'h') {
			i += 4;
			if (try_getNum(para+i, &val) == 0) {
				Invalid_cmd();
				return ;
			}
		}
	} else {
		Invalid_cmd();
		return ;
	}
	if (k & 1)
		default_PC = val;
	if (k & 2)
		default_IM = val;
	if (k & 4)	
		default_DM = val;
	if (k & 8) {
		if (rn>=0 && rn<PPC_GPR_N)
			default_GPR[rn] = val;
		else
			Invalid_cmd();
	}
	if (k & 16)
		configure_help();
}

/*
 * Quit the whole program.
 */
void cmd_quit() {
    printf("Quit from Pluto...\n");
    exit (0);
}
