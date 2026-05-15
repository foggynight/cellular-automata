(* Elementary Cellular Automata in OCaml.
 * Copyright (C) 2026 Robert Coffey
 * Released under the MIT license. *)

let rec dec_to_bin x =
  if x = 0 then []
  else (x mod 2) :: (dec_to_bin (x / 2))

(* Convert an integer x into a rule. In elementary automata, there are 256
 * possible rules, thus x < 256.
 *
 * e.g. 120 (base 10) -> 01111000 (base 2)
 *      111 110 101 100 011 010 001 000    (rule array index)
 *       0   1   1   1   1   0   0   0     (next generation alive?)
 *
 * Here, a rule is just an array containing the binary representation of x in
 * little-endian order, padded with trailing zeroes to make rule 8 elements. *)
let num_to_rule x =
  assert (x < 256);
  let rule = Array.of_list (dec_to_bin x) in
  let len = Array.length rule in
  if len >= 8 then rule
  else Array.append rule (Array.init (8 - len) (fun i -> 0))

(* Get a number between 0 and 7 inclusive which represents the current state at
 * position i of the world.
 *
 * e.g. Living cell with left neighbor: 1 1 0 -> 6. This number is used to index
 * a rule and determine the next state at position i.
 *
 * The boundary of the world is treated as being 0. *)
let cell_state world i =
  assert (i < Array.length world);
    4 * (if i > 0 then world.(i-1) else 0)
  + 2 * world.(i)
  + (if i < (Array.length world) - 1 then world.(i+1) else 0)

let print_world world =
  Array.iter (fun cell -> print_char (if cell = 1 then '#' else '.')) !world;
  print_newline ()

let sim_world rule_num width steps =
  assert (rule_num < 256);

  let rule = num_to_rule rule_num in
  let world = ref (Array.init width (fun i -> 0)) in
  (!world).(width / 2 + width mod 2 - 1) <- 1;

  print_world world;
  for i = 1 to steps do
    let copy = Array.copy !world in

    for i = 0 to ((Array.length !world) - 1) do
      let state = cell_state !world i in
      copy.(i) <- rule.(state)
    done;

    world := copy;
    print_world world
  done
