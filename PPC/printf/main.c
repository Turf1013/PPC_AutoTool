#include "arch_cocoa.h"
#include "keyboard.h"
#include "display.h"

#define SEGMENT_NUM 4

void read_WordTotal(void);
void handle_hw_int(void);

int main( void )
{
	/* disable interrupt first */
	cpu_disable_irq();
	
	// All the Initialize
	display_init();
	keyboard_init();
	
	/* enable interrupt latter */
	cpu_enable_irq();
	unsigned int k = 10;

	while (1)
	{	
		read_WordTotal();
		k /= 13;
	}
	
	return 0;	
}

void read_WordTotal(void)
{
	unsigned int *keyboard_p;
	unsigned int total;
	unsigned int *led_p;
	
	led_p = (unsigned int *)(BASE_DEV + MINOR_BASE_LED);
	
	// segment_p = (unsigned int *)(BASE_DEV + MINOR_BASE_SEGMENT);
	keyboard_p = (unsigned int *)(BASE_DEV + MINOR_BASE_KEYBOARD);
	total = *(keyboard_p + KEYBOARD_SUM/4);
	
	
	// only one interrupt
	*led_p = total;
}

void handle_hw_int( void )
{
	keyboard_interrupt();
}
