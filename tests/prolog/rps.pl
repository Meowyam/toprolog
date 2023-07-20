move(rock).
move(paper).
move(scissors).

beats(rock, scissors).
beats(paper, rock).
beats(scissors, paper).

valid_move(Move) :- move(Move).

winner(Player1Move, Player2Move, Winner) :-
    valid_move(Player1Move),
    valid_move(Player2Move),
    beats(Player1Move, Player2Move),
    Winner = 'Player 1';
    beats(Player2Move, Player1Move),
    Winner = 'Player 2';
    Winner = 'Tie'.

