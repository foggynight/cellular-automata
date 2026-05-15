#include <SDL2/SDL.h>

#include <stdio.h>
#include <stdlib.h>

#include "cell.h"
#include "engine.h"
#include "screen.h"

#define TARGET_FPS 60                  // Target number of frames to render per second
#define SLEEP_TIME (1000 / TARGET_FPS) // Number of milliseconds to sleep after updating the screen

#define MONITOR_RESOLUTION_WIDTH  1920 // Width in pixels of the user's monitor
#define MONITOR_RESOLUTION_HEIGHT 1080 // Height in pixels of the user's monitor

static SDL_Window *win;
static SDL_Renderer *ren;

int screen_init(int monitor)
{
    if (SDL_Init(SDL_INIT_VIDEO)) {
        fprintf(stderr, "Error: SDL_Init: %s\n", SDL_GetError());
        return 1;
    }

    win = SDL_CreateWindow("Game of Life",
            monitor * MONITOR_RESOLUTION_WIDTH, 0,
            CELL_ARRAY_WIDTH, CELL_ARRAY_HEIGHT,
            SDL_WINDOW_SHOWN);
    if (!win) {
        fprintf(stderr, "Error: SDL_CreateWindow: %s\n", SDL_GetError());
        return 1;
    }

    ren = SDL_CreateRenderer(win, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);
    if (!ren) {
        fprintf(stderr, "Error: SDL_CreateRenderer: %s\n", SDL_GetError());
        if (win) SDL_DestroyWindow(win);
        SDL_Quit();
        return 1;
    }

    return 0;
}

int screen_step(cell_t *cell_arr)
{
    static SDL_Event event;

    while (SDL_PollEvent(&event)) {
        if (event.type == SDL_QUIT
            || (event.type == SDL_WINDOWEVENT
                && event.window.event == SDL_WINDOWEVENT_CLOSE))
        {
            return 1;
        }
    }

    SDL_SetRenderDrawColor(ren, 0x00, 0x00, 0x00, 0x00);
    SDL_RenderClear(ren);
    SDL_SetRenderDrawColor(ren, 0xFF, 0xFF, 0x00, 0xFF);

    /* Draw pixel array to the renderer */
    for (int i = 0; i < CELL_ARRAY_WIDTH; ++i) {
        for (int j = 0; j < CELL_ARRAY_HEIGHT; ++j) {
            if (cell_arr[j*CELL_ARRAY_WIDTH + i].live) {
                SDL_RenderDrawPoint(ren, i, j);
            }
        }
    }

    SDL_RenderPresent(ren);
    SDL_Delay(SLEEP_TIME);

    return 0;
}

void screen_destroy(void)
{
    SDL_DestroyRenderer(ren);
    SDL_DestroyWindow(win);
    SDL_Quit();
}
