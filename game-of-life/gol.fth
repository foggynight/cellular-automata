#! /usr/bin/env -S gforth --die-on-signal

\ gol.fth - Game of Life in GForth
\ Copyright (C) 2022 Robert Coffey
\ Released under the GPLv3.

40 constant width
24 constant height
width height * constant size

create b1 size chars allot b1 size chars erase
create b2 size chars allot b2 size chars erase

: <rot ( a b c -- c a b )   rot rot ;
: +.+ ( n1 n2 d1 d2 -- n1+d1 n2+d2 )   rot + <rot + swap ;

: b>sym ( b -- c )   if [char] O else [char] . then ;
: pos>off ( x y -- off )   width * + chars ;

: on ( board x y -- )   pos>off + true swap c! ;
: off ( board x y -- )   pos>off + false swap c! ;
: on? ( board x y -- f )   pos>off + c@  ;
: get ( board x y -- c )   on? b>sym ;

: copy ( src dst -- )
  swap ( ... -- dst src )
  size 0 do
    2dup i swap + c@ ( ... -- dst src dst c@[src+i] )
    i rot + c!       ( ... -- dst src )
  loop 2drop ;

: valid? ( x y -- f )
  dup 0>= swap height < and
  swap dup 0>= swap width < and
  and ;

: neighbors ( x y -- cnt )
  0 <rot ( x y -- cnt x y )
  2 -1 do
    2 -1 do
      i 0= j 0= and invert if ( cnt x y -- cnt x y )
        2dup i j +.+ ( ... -- cnt x y nx ny )
        2dup valid? if ( ... -- cnt x y nx ny )
          b2 <rot on? if ( ... -- cnt x y )
            rot 1+ <rot ( ... -- cnt+1 x y )
          then
        else 2drop ( ... -- cnt x y )
        then then
    loop loop 2drop ;

: init ( -- )
  b1 1 1 on
  b1 3 1 on
  b1 2 2 on
  b1 3 2 on
  b1 2 3 on ;

: reset ( -- )
  height 0 do
    width 0 do
      b1 i j off
    loop loop ;

: update ( -- )
  b1 b2 copy
  height 0 do
    width 0 do
      i j neighbors
      dup 2 < if b1 i j off else
      dup 3 > if b1 i j off else
      dup 3 = if b1 i j on
      then then then drop
    loop loop ;

: draw ( -- )
  page
  height 0 do
    width 0 do
      b1 i j get emit
    loop cr loop ;

: play ( -- )   reset init draw begin 500 ms update draw again ;

play
