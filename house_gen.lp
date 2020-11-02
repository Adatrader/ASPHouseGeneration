% Construction types
construction_type(wall;door;floor;bed).
 
% 1 bed, 2 doors, 8 floor, 14 walls (square house)
:- {construction(XX,YY,wall)} != 14.
:- {construction(XX,YY,floor)} !=8.
:- {construction(XX,YY,door)} != 2.
:- {construction(XX,YY,bed)} !=1.

% Don't place on water, tree, bridge
0 {construction(XX,YY,TYPE) : construction_type(TYPE)} 1 :- width(XX), height(YY).
:- construction(XX,YY,_), terrain(XX,YY,water).
:- construction(XX,YY,_), terrain(XX,YY,tree).
:- construction(XX,YY,_), terrain(XX,YY,bridge).

% Same as terrain but for construction
neighbors_construction(XX,YY,TYPE, COUNT) :-
	    COUNT =  {construction(XX-1,YY-1,TYPE);
					      construction(XX,YY-1,TYPE);
					      construction(XX+1,YY-1,TYPE);
					      construction(XX-1,YY,TYPE);
					      construction(XX+1,YY,TYPE);
					      construction(XX-1,YY+1,TYPE);
					      construction(XX,YY+1,TYPE);
					      construction(XX+1,YY+1,TYPE)},
					      construction(XX,YY,_),
					      construction_type(TYPE).
					
immediate_neighbors_construction(XX,YY,TYPE, COUNT) :-
	    COUNT =  {construction(XX,YY-1,TYPE);
					      construction(XX-1,YY,TYPE);
					      construction(XX+1,YY,TYPE);
					      construction(XX,YY+1,TYPE)},
					      construction(XX,YY,_),
					      construction_type(TYPE).

% Don't open onto water
:- construction(XX,YY,door), immediate_neighbors(XX,YY,water, COUNT), COUNT > 0.

% Block side by side doors
double_door(XX,YY) :- construction(XX,YY,door), construction(XX,YY-1,wall), construction(XX,YY+1,wall).
double_door(XX,YY) :- construction(XX,YY,door), construction(XX-1,YY,wall), construction(XX+1,YY,wall).
:- construction(XX,YY,door), not double_door(XX,YY).

% Make a square floor around bed (Reference point for walls to surround interior space)
:- construction(XX,YY,bed), neighbors_construction(XX,YY,floor, F_COUNT), F_COUNT != 8.

% Wall near 1 diagonal floor (corner) or straight wall piece with 2-3 tiles
:- construction(XX,YY,wall), neighbors_construction(XX,YY,floor, F_COUNT), F_COUNT != 1, F_COUNT != 2, F_COUNT != 3.
