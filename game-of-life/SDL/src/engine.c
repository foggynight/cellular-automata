#include <string.h>

#include "cell.h"
#include "engine.h"

static cell_t cell_arr[CELL_COUNT];

void engine_setup(void)
{
    /* Initialize cell array */
    for (cell_t *walk = cell_arr; walk < cell_arr + CELL_COUNT; ++walk)
        cell_init(walk);

    /* Add neighbours to each cell */
    for (int i = 0, ni; i < CELL_COUNT; ++i) {
        cell_t *targ = &cell_arr[i]; // Target cell

        /* Cell above */
        if (i >= CELL_ARRAY_WIDTH) {
            ni = i - CELL_ARRAY_WIDTH;
            cell_add_neighbour(targ, &cell_arr[ni]);
        }

        /* Cell below */
        if (i < CELL_ARRAY_WIDTH * (CELL_ARRAY_HEIGHT-1)) {
            ni = i + CELL_ARRAY_WIDTH;
            cell_add_neighbour(targ, &cell_arr[ni]);
        }

        /* Column to the left */
        if (i%CELL_ARRAY_WIDTH > 0) {
            /* Cell above to the left */
            if (i >= CELL_ARRAY_WIDTH) {
                ni = i - CELL_ARRAY_WIDTH - 1;
                cell_add_neighbour(targ, &cell_arr[ni]);
            }

            /* Cell directly to the left */
            ni = i - 1;
            cell_add_neighbour(targ, &cell_arr[ni]);

            /* Cell below to the left */
            if (i < CELL_ARRAY_WIDTH * (CELL_ARRAY_HEIGHT-1)) {
                ni = i + CELL_ARRAY_WIDTH - 1;
                cell_add_neighbour(targ, &cell_arr[ni]);
            }
        }

        /* Column to the right */
        if (i%CELL_ARRAY_WIDTH < CELL_ARRAY_WIDTH-1) {
            /* Cell above to the right */
            if (i >= CELL_ARRAY_WIDTH) {
                ni = i - CELL_ARRAY_WIDTH + 1;
                cell_add_neighbour(targ, &cell_arr[ni]);
            }

            /* Cell directly to the right */
            ni = i + 1;
            cell_add_neighbour(targ, &cell_arr[ni]);

            /* Cell below to the right */
            if (i < CELL_ARRAY_WIDTH * (CELL_ARRAY_HEIGHT-1)) {
                ni = i + CELL_ARRAY_WIDTH + 1;
                cell_add_neighbour(targ, &cell_arr[ni]);
            }
        }
    }

    /* BEGIN: TESTING */
    for (int i = 0; i < CELL_ARRAY_WIDTH; ++i)
        cell_arr[i].live = 1;
    for (int i = 0; i < CELL_ARRAY_WIDTH; ++i)
        cell_arr[i+CELL_ARRAY_WIDTH*(CELL_ARRAY_HEIGHT-1)].live = 1;
    for (int i = 0; i < CELL_ARRAY_HEIGHT; ++i)
        cell_arr[i*CELL_ARRAY_WIDTH].live = 1;
    for (int i = 1; i <= CELL_ARRAY_HEIGHT; ++i)
        cell_arr[i*CELL_ARRAY_WIDTH-1].live = 1;
    /* ENDOF: TESTING */
}

cell_t *engine_view(void)
{
    return cell_arr;
}

void engine_step(void)
{
    /* Check if each cell should live this turn */
    for (int i = 0; i < CELL_COUNT; ++i)
        cell_check(&cell_arr[i]);
    /* Update each cell */
    for (int i = 0; i < CELL_COUNT; ++i)
        cell_update(&cell_arr[i]);
}
