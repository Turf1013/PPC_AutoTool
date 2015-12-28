#ifndef __ARCH_COCOA_H
#define __ARCH_COCOA_H

// false & true
#define FALSE 0
#define TRUE  1

/* Device address */
#define BASE_DEV            0x10020000

// TC0
#define MINOR_BASE_TC0      0x0000
    #define TC0_MODE	    0x0
    #define TC0_RESET  		0x4
    #define TC0_COUNT    	0x8
		
// LED
#define MINOR_BASE_LED      0x0100
	
// Keyboard
#define MINOR_BASE_KEYBOARD 0x0200
	#define KEYBOARD_SR		0x0
	#define KEYBOARD_SUM	0x4
	#define KEYBOARD_DATA	0x8
	#define KEYBOARD_FLAG	0xC
	
// Graphic Card
#define MINOR_BASE_GRAPHIC_REG  0x0300
	#define GRAPHIC_ORIGIN  	0x0
	#define GRAPHIC_CURSOR_X	0x4
	#define GRAPHIC_CURSOR_Y	0x8
#define MINOR_BASE_GRAPHIC_MEM  0x1000	

 

#endif  /* __ARCH_COCOA_H */