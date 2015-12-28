#include "arch_cocoa.h"
#include "display.h"
#include "keyboard.h"
#include "regdef.h"

static unsigned int x_glb;
static unsigned int y_glb;
static unsigned int pos_glb;
static unsigned int top_glb;
static unsigned int bottom_glb;
unsigned int origin_glb;
unsigned int src_end_glb;
unsigned int video_mem_start;
unsigned int video_mem_end;

static void lf();
static void cr();
static void scrup();
static void scrdown();

void display_init()
{
	unsigned int i = DISPLAY_WIDTH * DISPLAY_HEIGHT / 2;
	unsigned int *Two_Words_p;
	
	video_mem_start = (unsigned int)(BASE_DEV + MINOR_BASE_GRAPHIC_MEM);
	video_mem_end = video_mem_start + 0x1000 - 4;		/* MAX address */
	origin_glb = video_mem_start;
	src_end_glb = video_mem_start + DISPLAY_HEIGHT * DISPLAY_SIZE_ROW;
	/* initial the position and x&y */
	display_set_position(0, 0);
	top_glb = 0;
	bottom_glb = DISPLAY_HEIGHT;
	
	/* write the blank char into Display-Memory */
	Two_Words_p = (unsigned int *)(BASE_DEV + MINOR_BASE_GRAPHIC_MEM);
	while (i--)
	{
		/*
		 * 0x2007 is the default space word(16bit),
		 * Double it, we can fill the memory more faster.
		 */
		*Two_Words_p++ = 0x07200720;
	}
}

void display_clear()
{
	unsigned int i = DISPLAY_WIDTH * DISPLAY_HEIGHT / 2;
	unsigned int *Two_Words_p;
	
	/* initial the position and x&y */
	display_set_position(0, 0);
	
	/* clear the video-memory */
	/* offset address is i * 2, just equal i << 1. */
	Two_Words_p = (unsigned int *)(BASE_DEV + MINOR_BASE_GRAPHIC_MEM);
	while (i--)
	{
		/*
		 * 0x2007 is the default space word(16bit),
		 * Double it, we can fill the memory more faster.
		 */
		*Two_Words_p++ = 0x07200720;
	}
}

/* display a char with default colour */
void display_write_byte(unsigned int key)
{
	word_t word_tmp;
	word_t *word_p;
	unsigned int ui_tmp;
	
	switch (key)
	{
	case DELETE:					/* Delete */
		/* means clear in this app */
		display_clear();
		break;
		
	case  BACKSPACE:				/* BackSpace */
		if (x_glb)
		{
			x_glb --;
			pos_glb -= 2;	
		}
		/* fill with space */
		word_p = (word_t *)pos_glb;
		word_p->value = 0x20;
		word_p->attribute = 0x07;
		break;
		
	case  TAB:						/* Tab */
		/* 7 = 4'b1111, This is very clever. */
		ui_tmp = 8 - (x_glb & 7);
		x_glb += ui_tmp;
		pos_glb += ( ui_tmp << 1 );
		if (x_glb > DISPLAY_WIDTH)
		{
			x_glb -= DISPLAY_WIDTH;
			pos_glb -= DISPLAY_SIZE_ROW;
			lf();
		}
		break;
		
	case ENTER:						/* Enter */
		cr();	
		lf();
		break;
	
	default:
		if (key > 31 && key < 127)
		{
			if (x_glb >= DISPLAY_WIDTH)
			{
				x_glb -= DISPLAY_WIDTH;
				pos_glb -= DISPLAY_SIZE_ROW;
				lf();
			}
			word_tmp.value = (unsigned char)key;
			word_tmp.attribute = DEFAULT_CHAR_COLOR;
			// write the word and not overflow
			if (pos_glb > video_mem_end)
				return ;
			word_p = (word_t *)pos_glb;
			word_p->value = word_tmp.value;
			word_p->attribute = word_tmp.attribute;
			// refresh the position
			pos_glb += 2;
			x_glb++;
		}
	}
}

static void lf()
{
	if (y_glb < bottom_glb)
	{
		y_glb++;
		pos_glb += DISPLAY_SIZE_ROW;
		return ;
	}
	scrup();
}

static void cr()
{
	pos_glb -= ( x_glb << 1 );
	x_glb = 0;
}

static void scrup()
{	
	/* do nothing */
}

static void scrdown()
{
	/* do nothing */
}

void display_set_position(unsigned int new_x, unsigned int new_y)
{
	if (new_x > DISPLAY_WIDTH || new_y > DISPLAY_HEIGHT)
	{
		return ;
	}
	x_glb = new_x;
	y_glb = new_y;
	// pos_glb = origin_glb + new_y * DISPLAY_SIZE_ROW + ( new_x << 1 );
	// new_y * 160 = new_y * 128 + new_y * 32
	pos_glb = origin_glb + (new_y << 7) + (new_y << 5) + (new_x << 1); 
}

void display_set_cursor( void )
{
	unsigned int *word_p;
	
	// cpu_disable_irq();
	word_p = (unsigned int *)(BASE_DEV + MINOR_BASE_GRAPHIC_REG);
	*(word_p + GRAPHIC_CURSOR_X/4) = x_glb;
	*(word_p + GRAPHIC_CURSOR_Y/4) = y_glb;
	// cpu_enable_irq();
}

void display_get_cursor(unsigned int *x, unsigned int *y)
{
	unsigned int *word_p;
	
	// cpu_disable_irq();
	word_p = (unsigned int *)(BASE_DEV + MINOR_BASE_GRAPHIC_REG);
	*x = *(word_p + GRAPHIC_CURSOR_X/4);
	*y = *(word_p + GRAPHIC_CURSOR_Y/4);
	// cpu_enable_irq();
}

/* wrong!!! I hate AT&T assemble */
void cpu_disable_irq()
{
	unsigned int p ;
    
    asm( "mfmsr %0" 
        :"=r"(p)
    ) ;
    
    p = p & ~MSR_EE;
	
	asm( "mtmsr %0" 
		:
        :"r"(p)
    ) ;
}

/* wrong!!! I hate AT&T assemble */
void cpu_enable_irq()
{
	unsigned int p ;
    
    asm( "mfmsr %0" 
        :"=r"(p)
    ) ;
    
    p = p | MSR_EE;
	
	asm( "mtmsr %0" 
        :
        :"r"(p)
    ) ;
}
