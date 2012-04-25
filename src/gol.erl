-module(gol).
-compile(export_all).

pot_neighbors({ X1, Y1 }) ->
  XX = lists:seq(X1 - 1, X1 + 1),
  YY = lists:seq(Y1 - 1, Y1 + 1),
  % generate all possible neighbors, excluding self
  [ {X, Y} || X <- (XX), Y <- (YY), not( (X == X1) and (Y == Y1) ) ].

neighbors(Cell, Grid) ->
  PotNeighbors = pot_neighbors(Cell),
  Neighbors = sets:intersection(sets:from_list(Grid),
                                sets:from_list(PotNeighbors)),
  sets:to_list(Neighbors).

next_state(State, 2) -> State;
next_state(_, 3)     -> alive;
next_state(_, _)     -> dead.

curr_state(Cell, Grid) ->
  case lists:member(Cell, Grid) of
    true -> alive;
    false -> dead
  end.

tick_cell(Cell, Grid) ->
  CurrState = curr_state(Cell, Grid),
  Neighbors = neighbors(Cell, Grid),
  NeighborsCount = length(Neighbors),
  next_state(CurrState, NeighborsCount).

min_cell(Grid) -> lists:min(Grid).
max_cell(Grid) -> lists:max(Grid).

all_possible_cells(Grid) ->
  { MinX, MinY } = min_cell(Grid),
  { MaxX, MaxY } = max_cell(Grid),
  [ { X, Y } || X <- lists:seq(MinX - 1, MaxX + 1),
                Y <- lists:seq(MinY - 1, MaxY + 1) ].

tick(Grid) ->
  AliveFilter = fun(Cell) ->
    tick_cell(Cell, Grid) == alive
  end,
  lists:filter(AliveFilter, all_possible_cells(Grid)).

-ifdef(TEST).
-include_lib("../test/gol.hrl").
-endif.
