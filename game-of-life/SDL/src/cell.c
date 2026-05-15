#include "cell.h"
#include "rtb_list.h"

static int get_living_neighbours(cell_t *cell);

void cell_init(cell_t *targ)
{
    targ->live = targ->next = 0;
    targ->n_cells = sl_create_list();
}

void cell_check(cell_t *targ)
{
    int next = targ->live;
    int n_count = get_living_neighbours(targ);
    if (n_count < 2)
        next = 0;
    else if (n_count > 3)
        next = 0;
    else if (n_count == 3)
        next = 1;
    targ->next = next;
}

void cell_update(cell_t *targ)
{
    targ->live = targ->next;
}

void cell_add_neighbour(cell_t *targ, cell_t *neigh)
{
    sl_node_t *new_node = sl_create_node();
    new_node->val = neigh;
    sl_append(targ->n_cells, new_node);
}

static int get_living_neighbours(cell_t *targ)
{
    int count = 0;
    for (sl_node_t *walk = targ->n_cells->head; walk; walk = walk->next)
        if (((cell_t *)walk->val)->live)
            ++count;
    return count;
}
