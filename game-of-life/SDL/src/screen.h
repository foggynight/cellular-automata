#ifndef SCREEN_H_
#define SCREEN_H_

#include "cell.h"

/** screen_init: Initialize the screen.
 * @param monitor {int}: ID of the monitor to place the window on
 * @return {int}: Non-zero on failure */
int screen_init(int monitor);

/** screen_step: Update the screen.
 * @param cell_arr {cell_t *}: Array of cells
 * @return {int}: Non-zero indicates time to quit */
int screen_step(cell_t *cell_arr);

/** screen_destroy: Destroy the screen. */
void screen_destroy(void);

#endif
