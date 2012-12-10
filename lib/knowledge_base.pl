:- module(knowledge_base, []).

% nodes
node(1, 'собака').
node(2, 'кошка').
node(3, 'сторожит').
node(4, 'сидит на цепи').
node(5, 'лает').
node(6, 'большая').
node(7, 'ловит мышей').
node(8, 'мяукает').

% hypotheses
hypothesisNode(1).
hypothesisNode(2).

% terminals
terminalNode(5).
terminalNode(6).
terminalNode(7).
terminalNode(8).

% implications
implication(and, 3, 5, 6, 0.9).
implication(simple, 4, dummy, negative, dummy, 1.0).
implication(and, 2, 6, 7, negative, positive, 0.75).
implication(and, 2, 6, 8, negative, positive, 1.0).
implication(and, 2, 7, 8, positive, positive, 1.0).
implication(and, 1, 3, 4, positive, positive, 0.9).

