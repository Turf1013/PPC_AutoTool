#ifndef _DISPLAY_H
#define _DISPLAY_H

typedef struct {
    unsigned char value;
    unsigned char attribute;
} word_t;

#define BLINK           0x80
#define LIGHT           0x08
#define RED             0x4
#define GREEN           0x2
#define BLUE            0x1
#define WHITE           (RED+GREEN+BLUE)
#define BLACK           (0+0+0)
#define YELLOW          (RED+GREEN+0) 
#define ATTRIBUTE(blink, light, fg, bg) (blink + (bg<<4) + light + fg)

#define DISPLAY_WIDTH 		80
#define DISPLAY_HEIGHT 		25
#define DISPLAY_SIZE_ROW	160

#define DEFAULT_CHAR_COLOR	0x07

/*
 * video ram = 80 * 25 * 2 = 4000 byte = 4KB
 */

/* some realy important variable */ 
extern unsigned int origin_glb;
extern unsigned int src_end_glb;
extern unsigned int video_mem_start;
extern unsigned int video_mem_end;

/* some functions */
extern void display_init();
extern void display_clear();
extern void display_write_byte(unsigned int);
extern void display_set_position(unsigned int new_x, unsigned int new_y);
extern void display_get_curosr(unsigned int *, unsigned int *);
extern void display_set_cursor();
extern void cpu_disable_irq();
extern void cpu_enable_irq();

#endif