#include <stdarg.h>
#include "arch_cocoa.h"
#include "keyboard.h"
#include "keymap.h"
#include "display.h"

void keyboard_init()
{
	unsigned int *keyboard_p;
	
	keyboard_p = (unsigned int *)(BASE_DEV + MINOR_BASE_KEYBOARD);
	
	// inital the Status-Register
	*(keyboard_p + (KEYBOARD_SR>>2))   = KEYBOARD_SR_INITIAL;
	*(keyboard_p + (KEYBOARD_DATA>>2)) = KEYBOARD_DATA_INITIAL;
	*(keyboard_p + (KEYBOARD_FLAG>>2)) = KEYBOARD_FLAG_INITIAL;
	*(keyboard_p + (KEYBOARD_SUM>>2))  = 0;
}

void keyboard_interrupt()
{
	unsigned int *keyboard_p;
	unsigned char scan_code;
	unsigned int key;
	
	keyboard_p = (unsigned int *)(BASE_DEV + MINOR_BASE_KEYBOARD);
	
	// just use key to get the Data-Register
	key =  *(keyboard_p + (KEYBOARD_DATA>>2));
	scan_code = (unsigned char)key;
	keyboard_decoder(scan_code, &key);
	display_write_byte(key);
	display_set_cursor();
	
	// recalculate the total word
	keyboard_total(key);
	
	*(keyboard_p + (KEYBOARD_SR>>2)) = KEYBOARD_SR_INITIAL;
}

void keyboard_total(unsigned int key)
{
	unsigned int *keyboard_p;
	unsigned int total = 0;
	
	keyboard_p = (unsigned int *)(BASE_DEV + MINOR_BASE_KEYBOARD);
	total = *(keyboard_p + (KEYBOARD_SUM>>2));
	
	if (key > 31 && key < 127)
		total++;
	else if (key == DELETE)
		total = 0;
	else if (key == BACKSPACE)
		total--;
	else if (key == ENTER)
		total++;
	else if (key == TAB)
		total = total + 4;
	else
		/* total is not change. */;
		
	*(keyboard_p + (KEYBOARD_SUM>>2)) = total;	
}

void keyboard_decoder(unsigned char scan_code, unsigned int *key_p)
{
	unsigned int *keyboard_p;
	unsigned int flag, index;
	unsigned int upper = 0;
	unsigned short ch;
	
	keyboard_p = (unsigned int *)(BASE_DEV + MINOR_BASE_KEYBOARD);
	flag = *(keyboard_p + (KEYBOARD_FLAG>>2));	
	
	if (scan_code == 0xE0)
	{
		/* do nothing just for now. */
		return ;
	}
	else if (scan_code == 0xE1)
	{
		/* do nothing just for now. */
		return ;
	}
	else
	{
		index = scan_code << 1;
		
		if ( flag & KEYBOARD_MODE_ALT )
		{
			/* do nothing just for now. */
		}
		
		if ( flag & KEYBOARD_MODE_CTRL )
		{
			/* do nothing just for now. */
		}
		
		if ( flag & KEYBOARD_MODE_CAPS )
		{
			upper = ~upper;
		}
		
		if ( flag & KEYBOARD_MODE_SHIFT )
		{
			upper = ~upper;
			index = scan_code + 1;
		}
		
		ch = keymap[index];
		
		// if upper is valid, then turn the 'a' to 'A'.
		// But sometimes we press the caps and shift, then need to fix it.
		if ( upper == 0 )
		{
			if ( ch >= 'A' && ch <= 'Z' )
			{
				ch = ch + 0x20;	/* A -> a */
			}
		}
		else
		{
			if ( ch >= 'a' && ch <= 'z' )
			{
				ch = ch - 0x20; /* a -> A */
			}
		}
		
		// if the char is a function charaster, then just give a NULL to this pointer.
		*key_p = (unsigned int)ch;
	}
}