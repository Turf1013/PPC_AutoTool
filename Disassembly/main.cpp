#include <fstream>
#include <iostream>
#include <string.h>
using namespace std;

#define OP_MAXLEN       10
#define OP_MAXNUM       64
#define FUNCT_MAXLEN    10
#define FUNCT_MAXNUM    64
#define INSTR_MAXNUM    128

// new OPcode for some mix instruction
#define BGEZ_NEWOP      56
#define MFC0_NEWOP      57
#define MTC0_NEWOP      58
#define MTC1_NEWOP      59
#define MTC2_NEWOP      60
#define MADD_NEWOP      61
#define MADDU_NEWOP     62

#define myassert(expr)\
    if (!(expr))\
    {\
        printf("something may be wrong.\n");\
    }

int comp ( const void *a, const void *b )
{
    return * ( int * ) a - * ( int * ) b;
}


// struct 3 types of instruction, pay attention to **Little ENDIAN**。
typedef	struct {
    unsigned instr_funct 	: 6  ;		// funct
    unsigned instr_shamt 	: 5  ;		// shamt
    unsigned instr_rd    	: 5  ;     	// rd
    unsigned instr_rt    	: 5  ;     	// rt
    unsigned instr_rs    	: 5  ;	   	// rs
    unsigned instr_op    	: 6  ;	   	// op
} Instr_RTypePart_st;

typedef struct {
    unsigned instr_imme		: 16 ;		// imme
    unsigned instr_rt		: 5	 ;		//
    unsigned instr_rs    	: 5  ;	   	// rs
    unsigned instr_op    	: 6  ;	   	// op
} Instr_ITypePart_st;

typedef	struct {
    unsigned instr_target   : 26 ;	   	// rs
    unsigned instr_op    	: 6  ;	   	// op
} Instr_JTypePart_st;

typedef struct {
    union {
        Instr_RTypePart_st RType ;		// R-Type
        Instr_ITypePart_st IType ;		// I-Type
        Instr_JTypePart_st JType ;		// J-Type
    } instr_un;
} InstrDomain_st;

typedef struct {
    union {
        unsigned int instr_value;		// for shift
        char instr_part[4];				// for part
        InstrDomain_st instr_domain;	// for domain
    } instr_un;
} MIPS_Instr_st;

// swap the instruction
void swap(char src[]);

// ascii to hex
void asciiToHex(char src[], char des[]);

// get a instruction
void getInstrFromFile(MIPS_Instr_st &instr);
// put a instruction
void putInstrIntoFile(MIPS_Instr_st &instr);
// analyse a instruction
void analyseInstr_LE(MIPS_Instr_st &instr, int frequency[]);
void analyseInstrLE_op(MIPS_Instr_st &instr, unsigned int &op);
void analyseInstrLE_funct(MIPS_Instr_st &instr, unsigned int op,
                          unsigned int &funct);
void analyseInstrLE_special(MIPS_Instr_st &instr, unsigned int op,
                            unsigned int funct);
// calculate instruction frquency and put into file
void putFrquencyIntoFile(int frequency[], int total);

void printfTheInstr(MIPS_Instr_st instr);

// the instruction OP & funct
char Instr_op_TB[OP_MAXNUM][OP_MAXLEN] = {
/*     op	   	       Instruction      */
/* ==================================== */
/* 6'b000000 = 0   */   {"R-Type"},             //          20 ~ 16               20 ~ 16
/* 6'b000001 = 1   */   {"bltz"},               // bgez      00001    ;  bltz      00000    ; bgez -> 56;
/* 6'b000010 = 2   */   {"j"},
/* 6'b000011 = 3   */   {"jal"},
/* 6'b000100 = 4   */   {"beq"},
/* 6'b000101 = 5   */   {"bne"},
/* 6'b000110 = 6   */   {"blez"},
/* 6'b000111 = 7   */   {"bgtz"},
/* 6'b001000 = 8   */   {"addi"},
/* 6'b001001 = 9   */   {"addiu"},
/* 6'b001010 = 10  */   {"slti"},
/* 6'b001011 = 11  */   {"sltiu"},
/* 6'b001100 = 12  */   {"andi"},
/* 6'b001101 = 13  */   {"ori"},
/* 6'b001110 = 14  */   {"oriu"},
/* 6'b001111 = 15  */   {"lui"},

/*
 *(1) OP = 6'b010000 includes many instrctions
 *  1. eret:  funct = 6'b011000;
 *  2. mfc0:  rs = 5'b00000, 3~10bit = 0;
 *  3. mtc0:  rs = 5'b00100, 3~10bit = 0;
 *
 *(2) OP = 6'b010001 includes many instrctions
 *  1. mfc1:  rs = 5'b00000, 0~10bit = 0;
 *  2. mfhc1: rs = 5'b00011, 0~10bit = 0;			// omit
 *  3. mtc1:  rs = 5'b00100, 3~10bit = 0;
 *  3. mthc1: rs = 5'b00111, 3~10bit = 0;			// omit
 *
 *(3) OP = 6'b010010 includes many instrctions
 *  1. mfc2:  rs = 5'b00000, 0~10bit = Impl;		// omit
 *  2. mfhc2: rs = 5'b00011, 0~10bit = Impl;
 *  3. mtc2:  rs = 5'b00100, 0~10bit = Impl;		// omit
 *  2. mfhc2: rs = 5'b00111, 0~10bit = Impl;
 */

/* 6'b010000 = 16  */   {"eret"},			// make mfc0 -> 57; make mtc0 -> 58;
/* 6'b010001 = 17  */   {"mfc1"},			// make mtc1 -> 59;
/* 6'b010010 = 18  */   {"mfc2"},			// make mtc2 -> 60;
/* 6'b010011 = 19  */   {"prefx"},
/* 6'b010100 = 20  */   {"beql"},
/* 6'b010101 = 21  */   {"bnel"},
/* 6'b010110 = 22  */   {"blezl"},
/* 6'b010111 = 23  */   {"bgtzl"},
/* 6'b011000 = 24  */   {"\0"},
/* 6'b011001 = 25  */   {"\0"},
/* 6'b011010 = 26  */   {"\0"},
/* 6'b011011 = 27  */   {"\0"},

/*
 *(1) OP = 6'b011100 includes many instrctions
 *  1. madd:  funct = 6'b000000;
 *  2. maddu: funct = 6'b000001;
 *  3. mul:   funct = 6'b000010;
 *  4. sdbbp: funct = 6'b111111;
 */
/* 6'b011100 = 28  */   {"mul"},		// make madd -> 61; make maddu -> 62;
/* 6'b011101 = 29  */   {"\0"},
/* 6'b011110 = 30  */   {"\0"},
/* 6'b011111 = 31  */   {"rdwhr"},
/* 6'b100000 = 32  */   {"lb"},
/* 6'b100001 = 33  */   {"lh"},
/* 6'b100010 = 34  */   {"lwl"},
/* 6'b100011 = 35  */   {"lw"},
/* 6'b100100 = 36  */   {"lbu"},
/* 6'b100101 = 37  */   {"lhu"},
/* 6'b100110 = 38  */   {"lwr"},
/* 6'b100111 = 39  */   {"\0"},
/* 6'b101000 = 40  */   {"\0"},
/* 6'b101001 = 41  */   {"sh"},
/* 6'b101010 = 42  */   {"swl"},
/* 6'b101011 = 43  */   {"sw"},
/* 6'b101100 = 44  */   {"\0"},
/* 6'b101101 = 45  */   {"\0"},
/* 6'b101110 = 46  */   {"swr"},
/* 6'b101111 = 47  */   {"\0"},
/* 6'b110000 = 48  */   {"ll"},
/* 6'b110001 = 49  */   {"\0"},
/* 6'b110010 = 50  */   {"\0"},
/* 6'b110011 = 51  */   {"pref"},
/* 6'b111000 = 56  */   {"bgez"},
/* 6'b111001 = 57  */   {"mfc0"},
/* 6'b111010 = 58  */   {"mtc0"},
/* 6'b111011 = 59  */   {"mtc1"},
/* 6'b111100 = 60  */   {"mtc2"},
/* 6'b111101 = 61  */   {"madd"},
/* 6'b111110 = 62  */   {"maddu"},
/* 6'b111111 = 63  */   {"\0"},
};

// for R-type
char Instr_funct_TB[FUNCT_MAXNUM][FUNCT_MAXLEN] = {
/*     funct 	       Instruction      */
/* ==================================== */
/* 6'b000000 = 0   */   {"sll"},
/* 6'b000001 = 1   */   {"movf"},
/* 6'b000010 = 2   */   {"srl"},
/* 6'b000011 = 3   */   {"sra"},
/* 6'b000100 = 4   */   {"sllv"},
/* 6'b000101 = 5   */   {"\0"},
/* 6'b000110 = 6   */   {"srlv"},
/* 6'b000111 = 7   */   {"srav"},
/* 6'b001000 = 8   */   {"jr"},             // special & rt = 5'b00000, rd = 5'b00000
/* 6'b001001 = 9   */   {"jalr"},           // special & rt = 5'b00000
/* 6'b001010 = 10  */   {"movz"},
/* 6'b001011 = 11  */   {"movn"},
/* 6'b001100 = 12  */   {"syscall"},
/* 6'b001101 = 13  */   {"break"},
/* 6'b001110 = 14  */   {"\0"},
/* 6'b001111 = 15  */   {"sync"},
/* 6'b010000 = 16  */   {"mfhi"},
/* 6'b010001 = 17  */   {"mthi"},
/* 6'b010010 = 18  */   {"mflo"},
/* 6'b010011 = 19  */   {"mtlo"},
/* 6'b010100 = 20  */   {"\0"},
/* 6'b010101 = 21  */   {"\0"},
/* 6'b010110 = 22  */   {"\0"},
/* 6'b010111 = 23  */   {"\0"},
/* 6'b011000 = 24  */   {"mult"},
/* 6'b011001 = 25  */   {"multu"},
/* 6'b011010 = 26  */   {"div"},
/* 6'b011011 = 27  */   {"divu"},
/* 6'b011100 = 28  */   {"\0"},
/* 6'b011101 = 29  */   {"\0"},
/* 6'b011110 = 30  */   {"\0"},
/* 6'b011111 = 31  */   {"\0"},
/* 6'b100000 = 32  */   {"add"},
/* 6'b100001 = 33  */   {"addu"},
/* 6'b100010 = 34  */   {"sub"},
/* 6'b100011 = 35  */   {"subu"},
/* 6'b100100 = 36  */   {"and"},
/* 6'b100101 = 37  */   {"or"},
/* 6'b100110 = 38  */   {"xor"},
/* 6'b100111 = 39  */   {"nor"},
/* 6'b101000 = 40  */   {"sb"},
/* 6'b101001 = 41  */   {"\0"},
/* 6'b101010 = 42  */   {"slt"},
/* 6'b101011 = 43  */   {"sltu"},
/* 6'b101100 = 44  */   {"\0"},
/* 6'b101101 = 45  */   {"\0"},
/* 6'b101110 = 46  */   {"\0"},
/* 6'b101111 = 47  */   {"\0"},
/* 6'b110000 = 48  */   {"tge"},
/* 6'b110001 = 49  */   {"tgeu"},
/* 6'b110010 = 50  */   {"tlt"},
/* 6'b110011 = 51  */   {"tltu"},
/* 6'b110100 = 52  */   {"teq"},
/* 6'b110101 = 53  */   {"\0"},
/* 6'b110110 = 54  */   {"tne"},
/* 6'b110111 = 55  */   {"\0"},
/* 6'b111000 = 56  */   {"sc"},
/* 6'b111001 = 57  */   {"\0"},
/* 6'b111010 = 58  */   {"\0"},
/* 6'b111011 = 59  */   {"\0"},
/* 6'b111100 = 60  */   {"\0"},
/* 6'b111101 = 61  */   {"\0"},
/* 6'b111110 = 62  */   {"\0"},
/* 6'b111111 = 63  */   {"\0"}
};

fstream file_in_glb;
fstream file_coe_glb;
fstream file_rate_glb;

int main()
{
    int InstrFrequency[INSTR_MAXNUM];
    int total = 0;

    file_in_glb.open("C:\\bin.bin", ios::binary | ios::in);
    file_coe_glb.open("C:\\bin_coe.bin", ios::binary | ios::out);
    file_rate_glb.open("C:\\bin_rate.bin", ios::binary | ios::out);

    if ( !file_in_glb.is_open() )
        cout <<"Can not open the file."<<endl;

    MIPS_Instr_st mips_instr_tmp;
    // char str_4[20]={'\0'};

    file_coe_glb <<"memory_initialization_radix=16;\n";
    file_coe_glb <<"memory_initialization_vector=\n";
    file_rate_glb <<"  Instruction  Time\t\tRate\n";

    // clear the frequency
    int i;

    for (i=0;i<INSTR_MAXNUM;i++)
        InstrFrequency[i] = 0;

    while (!file_in_glb.eof())
    {
        total++;
        getInstrFromFile(mips_instr_tmp);
        putInstrIntoFile(mips_instr_tmp);
        analyseInstr_LE(mips_instr_tmp, InstrFrequency);
    }
    putFrquencyIntoFile(InstrFrequency, total);

    file_in_glb.close();
    file_coe_glb.close();
    file_rate_glb.close();

    return 0;
}

void printfTheInstr(MIPS_Instr_st instr)
{
    printf("value: %x\n", instr.instr_un.instr_value);
    printf("op:    %u\n", instr.instr_un.instr_domain.instr_un.RType.instr_op);
    printf("funct: %u\n", instr.instr_un.instr_domain.instr_un.RType.instr_funct);
}

void swap(char src[])
{
    char tmp;

    int i;

    for (i=0;i<2;i++)
    {
        tmp = src[i];
        src[i] = src[3-i];
        src[3-i] = tmp;
    }
}

void asciiToHex(char src[], char des[])
{
    unsigned char tmp;
    unsigned char ch;
    int i;

    for (i=0;i<4;i++)
    {
        tmp = ( (unsigned char) src[3-i] ) >> 4;
        if (tmp >= 10)
            ch = tmp - 10 + 'a';
        else
            ch = tmp + '0';
        des[i<<1] = ch;

        tmp = ( (unsigned char) src[3-i] ) - ( tmp << 4 );
        if (tmp >= 10)
            ch = tmp - 10 + 'a';
        else
            ch = tmp + '0';
        des[(i<<1)+1] = ch;
    }
}

void getInstrFromFile(MIPS_Instr_st &instr)
{
    // no need to check fin.eof()
    file_in_glb.read(instr.instr_un.instr_part, 4);
}

void putInstrIntoFile(MIPS_Instr_st &instr)
{
    char str_9[9];
    str_9[8] = '\n';

    // swap(instr.instr_un.instr_part);

    asciiToHex(instr.instr_un.instr_part, str_9);
    file_coe_glb.write(str_9, 9);
    // no need to close
}

void putFrquencyIntoFile( int frequency[], int total)
{
    int i, j;
    int len;
    float rate;

    for (i=0;i<INSTR_MAXNUM;i++)
    {
        rate = frequency[i] / ( (float) total );
        if (i < OP_MAXNUM)
        {
            len = strlen(Instr_op_TB[i]);
            if (len > 0)
            {
                file_rate_glb <<"\t"<<Instr_op_TB[i];
                if (len<11)
                {
                    for (j=0;j<11-len;j++)
                        file_rate_glb <<" ";
                }
            }
        }
        else
        {
            len = strlen(Instr_funct_TB[i-OP_MAXNUM]);
            if (len > 0)
            {
                file_rate_glb <<"\t"<<Instr_funct_TB[i-OP_MAXNUM];
                if (len<11)
                {
                    for (j=0;j<11-len;j++)
                        file_rate_glb <<" ";
                }
            }
        }
        if (len > 0)
            file_rate_glb <<"\t"<<frequency[i]<<"\t\t "<<rate<<"\n";
    }

    // no need to close
}

void analyseInstr_LE(MIPS_Instr_st &instr, int frequency[])
{
    unsigned int op;
    unsigned int funct;

    // op is the main process
    analyseInstrLE_op(instr, op);

    frequency[op]++;

    // if R-Type then analyse funct
    if (op == 0)
    {

        analyseInstrLE_funct(instr, op, funct);
        frequency[funct+OP_MAXNUM]++;
    }
}

void analyseInstrLE_op(MIPS_Instr_st &instr, unsigned int &op)
{
    unsigned int rs;

    op = instr.instr_un.instr_domain.instr_un.RType.instr_op;
    rs = instr.instr_un.instr_domain.instr_un.RType.instr_rs;


    // handle some instructions sharing the same op
    switch (op)
    {
        case 1 :
            //          rs
            /* 1.bltz   0
             * 2.bgez   1     ; bgez -> BGEZ_NEWOP
             */
            if (rs == 0)
                ;
            else if (rs == 1)
                op = BGEZ_NEWOP;
            else
                op = OP_MAXNUM - 1;
            break;

        case 16:
            // eret is just 0x42000018
            //          rs
            /* 1.mfc0   0
             * 2.mtc0   4
             * make mfc0 -> MFC0_NEWOP; make mtc0 -> MTC0_NEWOP;
             */
            if (instr.instr_un.instr_value == 0x42000018)
                ;
            else if (rs == 0)
                op = MFC0_NEWOP;
            else if (rs == 4)
                op = MTC0_NEWOP;
            else
                op = OP_MAXNUM - 1;
            break;

        case 17:
            //          rs
            /* 1.mfc1   0
             * 2.mtc1   4
             * make mtc1 -> MTC1_NEWOP;
             */
            if (rs == 0)
                ;
            else if (rs == 4)
                op = MTC1_NEWOP;
            else
                op = OP_MAXNUM - 1;
            break;

        case 18:
            //          rs
            /* 1.mfc2   0
             * 2.mtc2   4
             * make mtc2 -> MTC2_NEWOP;
             */
            if (rs == 0)
                ;
            else if (rs == 4)
                op = MTC2_NEWOP;
            else
                op = OP_MAXNUM - 1;
            break;

        case 28:
            //          rs
            /*  1.madd  0
             *  2.maddu 1
             *  3.mul   2
             *  make madd -> MADD_NEWOP; make maddu -> MADDU_NEWOP
             */
            if (rs == 2)
                ;
            else if (rs == 0)
                op = MADD_NEWOP;
            else if (rs == 1)
                op = MADDU_NEWOP;
            else
                op = OP_MAXNUM - 1;
            break;

        default:    ;   // do nothing
    }
}

void analyseInstrLE_funct(MIPS_Instr_st &instr, unsigned int op,
                          unsigned int &funct)
{
    myassert(op == 0);

    funct = instr.instr_un.instr_domain.instr_un.RType.instr_funct;

    switch (funct)
    {
        default:    ;   // do nothing
    }
}
