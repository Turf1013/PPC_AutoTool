#ifndef PPC_CMD_H
#define PPC_CMD_H

/*
 * Pluto Needs a console just like GDB.
 * 1. p(rint) [-rmid]: print
 *   parameter:
 *      -r [*a*] [*b*]: regs from rA to rB
 *      -i [*a*] [*b*]: imem from addrA to addrB
 *      -d [*a*] [*b*]: dmem from addrA to addrB
 * 2. e(xecute) [-nar]: Execute
 *   parameter:
 *      [-n]: Execute next instruction
 *      [-a]: Execute All instruction
 *      [-r]: ReExecute last instruction
 * 3. r(estart): Restart
 * 4. l(ink): [-abs] filename.Link file as BIN
 *   parameter:
 *      [-a]: Link ASCII File
 *      [-b]: Link Binary File
 *      [-s]: Link .asm File
 * 5. d(ump) [-mx]: dump BIN File
 *		[-m]: dump hex File used by Modelsim
 *		[-x]: dump hex FIle used by Xilinx
 * 6. c(onfigure): configure
 *      [-pc=XXX]: inital_PC = XXX;
 *      [-im=XXX]: inital_IM = XXX;
 *      [-dm=XXX]: inital_DM = XXX;
 *      [-rX=XXX]: GPR[X] = XXX;
 * 7. q(uit): Quit
 */

extern void cmd_print();
extern void cmd_execute();
extern void cmd_restart();
extern void cmd_link();
extern void cmd_dump();
extern void cmd_configure();
extern void cmd_quit();

extern void initial_cmd();
extern void which_cmd(char str[], int l);
extern void pluto_cmd();

#endif // PPC_CMD_H
