#ifndef CELL_H_
#define CELL_H_

#include "rtb_list.h"

/* Cell type representing a cellular automata. */
typedef struct cell {
    int live; // Is the cell alive
    int next; // Should the cell be alive next turn
    sl_list_t *n_cells; // List of neighbouring cells
} cell_t;

void cell_init(cell_t *targ);
void cell_check(cell_t *targ);
void cell_update(cell_t *targ);
void cell_add_neighbour(cell_t* targ, cell_t *neigh);

#endif
