-include_lib("eunit/include/eunit.hrl").

assert_generates_potential_neighbors_correctly_test() ->
  Cell = { 4, 5 },
  PotNeighbors = [{ 3, 4 }, { 4, 4 }, { 5, 4 },
                  { 3, 5 },           { 5, 5 },
                  { 3, 6 }, { 4, 6 }, { 5, 6 }],
  ?assertEqual(gol:pot_neighbors(Cell), lists:sort(PotNeighbors)).

assert_finds_0_neighbors_test() ->
  Cell = { 4, 5 },
  Grid = [Cell],
  Neighbors = [],
  ?assertEqual(gol:neighbors(Cell, Grid), Neighbors).

assert_finds_1_neighbors_test() ->
  Cell = { 4, 5 },
  Grid = [Cell, { 5, 5 }],
  Neighbors = [{ 5, 5 }],
  ?assertEqual(gol:neighbors(Cell, Grid), Neighbors).

assert_finds_1_neighbors_with_stranger_cells_test() ->
  Cell = { 4, 5 },
  Grid = [Cell, { 5, 5 }, { 9, 9 }],
  Neighbors = [{ 5, 5 }],
  ?assertEqual(gol:neighbors(Cell, Grid), Neighbors).

assert_any_live_cell_with_0_neighbors_dies_test() ->
  Cell = { 5, 5 },
  Grid = [Cell],
  ?assertEqual(gol:tick_cell(Cell, Grid), dead).

assert_any_live_cell_with_1_neighbors_dies_test() ->
  Cell = { 5, 5 },
  Grid = [Cell, { 5, 6 }],
  ?assertEqual(gol:tick_cell(Cell, Grid), dead).

assert_any_live_cell_with_2_neighbors_alive_test() ->
  Cell = { 5, 5 },
  Grid = [Cell, { 5, 6 }, { 4, 5 }],
  ?assertEqual(gol:tick_cell(Cell, Grid), alive).

assert_next_state_is_dead_if_lower_than_2_test() ->
  ?assertEqual(dead, gol:next_state(alive, 0)),
  ?assertEqual(dead, gol:next_state(alive, 1)).

assert_next_state_is_dead_if_current_state_is_dead_and_has_2_neighbors_test() ->
  ?assertEqual(dead, gol:next_state(dead, 2)).

assert_next_state_is_alive_if_current_state_is_alive_and_has_more_than_2_neighbors_test() ->
  ?assertEqual(alive, gol:next_state(alive, 2)).

assert_next_state_is_dead_if_greater_than_3_test() ->
  ?assertEqual(dead, gol:next_state(alive, 4)),
  ?assertEqual(dead, gol:next_state(alive, 5)),
  ?assertEqual(dead, gol:next_state(alive, 6)),
  ?assertEqual(dead, gol:next_state(alive, 7)),
  ?assertEqual(dead, gol:next_state(alive, 8)).

assert_next_state_is_alive_if_has_3_neighbors() ->
  ?assertEqual(alive, gol:next_state(dead, 3)),
  ?assertEqual(alive, gol:next_state(alive, 3)).

assert_world_any_live_cell_with_0_neighbors_dies_test() ->
  Grid = [{ 5, 5 }],
  NextGrid = gol:tick(Grid),
  ?assertNot(lists:member({ 5, 5 }, NextGrid)).

assert_world_any_live_cell_with_1_neighbors_dies_test() ->
  Grid = [ { 5, 5 }, { 5, 6 }],
  NextGrid = gol:tick(Grid),
  ?assertNot(lists:member({ 5, 5 }, NextGrid)).

assert_world_any_live_cell_with_2_neighbors_lives_test() ->
  Grid = [ { 4, 5 },
           { 5, 5 }, { 5, 6 } ],
  NextGrid = gol:tick(Grid),
  ?assert(lists:member({ 4, 5 }, NextGrid)).

assert_min_cell_is_the_most_left_and_above_test() ->
  MinCell = { 0, 0 },
  Grid = [ { 4, 4 }, MinCell ],
  ?assertEqual(MinCell, gol:min_cell(Grid)).

assert_max_cell_is_the_most_right_and_below_test() ->
  MaxCell = { 4, 4 },
  Grid = [ { 0, 0 }, MaxCell ],
  ?assertEqual(MaxCell, gol:max_cell(Grid)).

assert_still_life_block_test() ->
  Grid = [ { 1, 1 }, { 1, 2 },
           { 2, 1 }, { 2, 2 } ],
  ?assertEqual(Grid, gol:tick(Grid)).

assert_still_life_beehive_test() ->
  Grid = [           { 1, 2 }, { 1, 3 },
           { 2, 1 },                     { 2, 4 },
                     { 3, 2 }, { 3, 3 }            ],
  ?assertEqual(Grid, gol:tick(Grid)).

assert_still_life_boat_test() ->
  Grid = [ { 1, 1 }, { 1, 2 },
           { 2, 1 },           { 2, 3 },
                     { 3, 2 } ],
  ?assertEqual(Grid, gol:tick(Grid)).

assert_oscillator_blinker_period_1_test() ->
  Grid = [ { 1, 1 }, { 1, 2 }, { 1, 3 } ],
  NextGrid = [ { 0, 2 },
               { 1, 2 },
               { 2, 2 } ],
  ?assertEqual(NextGrid, gol:tick(Grid)),
  ?assertEqual(Grid, gol:tick(NextGrid)).

assert_oscillator_beacon_test() ->
  Grid = [ { 1, 1 }, { 1, 2 },
           { 2, 1 },
                                         { 3, 4 },
                               { 4, 3 }, { 4, 4 }  ],
  NextGrid = [ { 1, 1 }, { 1, 2 },
               { 2, 1 }, { 2, 2 },
                                   { 3, 3 }, { 3, 4 },
                                   { 4, 3 }, { 4, 4 }  ],
  ?assertEqual(NextGrid, gol:tick(Grid)),
  ?assertEqual(Grid, gol:tick(NextGrid)).
