#ifndef ENGINE_H_
#define ENGINE_H_

#include "cell.h"

#define CELL_ARRAY_WIDTH  480
#define CELL_ARRAY_HEIGHT 480
#define CELL_COUNT (CELL_ARRAY_WIDTH * CELL_ARRAY_HEIGHT)

void engine_setup(void);
cell_t *engine_view(void);
void engine_step(void);

#endif
