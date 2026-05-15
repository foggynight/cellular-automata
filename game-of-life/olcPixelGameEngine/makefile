CC=g++
CFLAGS=-lX11 -lGL -lpthread -lpng -lstdc++fs -std=c++17

SRCS=$(wildcard src/*.cpp)
PROG=game-of-life

all: $(PROG)

$(PROG): $(SRCS)
	$(CC) $(SRCS) -o $(PROG) $(CFLAGS)

.SILENT: import
import:
	[ ! -d "olcPixelGameEngine" ] &&\
		git clone https://github.com/OneLoneCoder/olcPixelGameEngine;\
	[ ! -f "src/olcPixelGameEngine.h" ] &&\
		cp olcPixelGameEngine/olcPixelGameEngine.h src;\

.PHONY: uninstall
uninstall:
	rm -rf olcPixelGameEngine src/olc* $(PROG)
