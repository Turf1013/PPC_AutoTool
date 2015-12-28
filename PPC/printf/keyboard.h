#ifndef _KEYBOARD_H
#define _KEYBOARD_H

// About the analysing the break code & make code
#define SCAN_CODE_NUM 	0x84		/* Number of Scan Code  		*/
#define KEYMAP_COL_NUM  0x2			/* Number of the keymap columns */	
#define FLAG_BREAK	  	0x80		/* Break Code					*/
#define FLAG_EXT		0x0100		/* Normal function keys			*/
#define FLAG_SHIFT_L	0x0200		/* Shift key					*/
#define FLAG_SHIFT_R	0x0400		/* Shift key					*/
#define FLAG_CTRL_L		0x0800		/* Control key					*/
#define FLAG_CTRL_R		0x1000		/* Control key					*/
#define FLAG_ALT_L		0x2000		/* Alternate key				*/
#define FLAG_ALT_R		0x4000		/* Alternate key				*/

// INITIAL VALUE
#define KEYBOARD_SR_INITIAL 	0
#define KEYBOARD_DATA_INITIAL	0
#define KEYBOARD_FLAG_INITIAL	0

// Special bit int the Registers
/*       SR register       */
#define KEYBOARD_MODE_INTR		0x1
/*      Flag register      */
#define KEYBOARD_MODE_CAPS		0x1
#define KEYBOARD_MODE_SHIFT		0x2
#define KEYBOARD_MODE_ALT		0x4
#define KEYBOARD_MODE_CTRL		0x8

// Special keys
#define ESC			(0x01 + FLAG_EXT)	/* Esc		*/
#define TAB			(0x02 + FLAG_EXT)	/* Tab		*/
#define ENTER		(0x03 + FLAG_EXT)	/* Enter	*/
#define BACKSPACE	(0x04 + FLAG_EXT)	/* BackSpace	*/

// Shift, Ctrl, Alt
#define SHIFT_L		(0x05 + FLAG_EXT)	/* L Shift	*/
#define SHIFT_R		(0x06 + FLAG_EXT)	/* R Shift	*/
#define CTRL_L		(0x07 + FLAG_EXT)	/* L Ctrl	*/
#define CTRL_R		(0x08 + FLAG_EXT)	/* R Ctrl	*/
#define ALT_L		(0x09 + FLAG_EXT)	/* L Alt	*/
#define ALT_R		(0x0A + FLAG_EXT)	/* R Alt	*/

// Lock keys
#define CAPS_LOCK	(0x0B + FLAG_EXT)	/* Caps Lock	*/
#define	NUM_LOCK	(0x0C + FLAG_EXT)	/* Number Lock	*/
#define SCROLL_LOCK	(0x0D + FLAG_EXT)	/* Scroll Lock	*/

// Function keys
#define F1			(0x11 + FLAG_EXT)	/* F1		*/
#define F2			(0x12 + FLAG_EXT)	/* F2		*/
#define F3			(0x13 + FLAG_EXT)	/* F3		*/
#define F4			(0x14 + FLAG_EXT)	/* F4		*/
#define F5			(0x15 + FLAG_EXT)	/* F5		*/
#define F6			(0x16 + FLAG_EXT)	/* F6		*/
#define F7			(0x17 + FLAG_EXT)	/* F7		*/
#define F8			(0x18 + FLAG_EXT)	/* F8		*/
#define F9			(0x19 + FLAG_EXT)	/* F9		*/
#define F10			(0x1A + FLAG_EXT)	/* F10		*/
#define F11			(0x1B + FLAG_EXT)	/* F11		*/
#define F12			(0x1C + FLAG_EXT)	/* F12		*/

// Control keys
#define DELETE		(0x20 + FLAG_EXT)	/* Delete	*/
#define HOME		(0x21 + FLAG_EXT)	/* Home		*/
#define END			(0x22 + FLAG_EXT)	/* End		*/
#define INS			(0x23 + FLAG_EXT)	/* Ins		*/
#define WIN			(0x24 + FLAG_EXT)	/* Win		*/
#define PAGEUP		(0x25 + FLAG_EXT)	/* Page Up	*/
#define PAGEDOWN	(0x26 + FLAG_EXT)	/* Page Down*/
#define UP			(0x27 + FLAG_EXT)	/* Up		*/
#define DOWN		(0x28 + FLAG_EXT)	/* Down		*/
#define LEFT		(0x29 + FLAG_EXT)	/* Left		*/
#define RIGHT		(0x2A + FLAG_EXT)	/* Right	*/ 

extern void keyboard_init();
extern void keyboard_interrupt();
extern void keyboard_decoder(unsigned char, unsigned int *);
extern void keyboard_total();

#endif