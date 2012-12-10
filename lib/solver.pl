:- module(solver, []).
:- use_module(knowledge_base, []).

:- dynamic
	answer/2,
	node_coefficient/2.

solver :-
	clear_database,
	not(get_all_answers),
	show_results,
	nl, write('Go fuck yourself!'),!.

% clearing prolog db from asserted rules
clear_database :-
	retractall(answer(_, _)), % DAT ASS
	retractall(node_coefficient(_, _)).

get_all_answers :-
	        get_single_answer,
		fail.
get_single_answer :-
	knowledge_base:hypothesisNode(N),
	infer_all_edges(N, C),
	infer_all_edges(N, C),
	assert(answer(N, C)).

infer_all_edges(N, C) :-
	findall(X, infer(N, X), Ls),
	nl, write('Ls='), write(Ls),
	supercombine(Ls, C).

infer(N, C) :-
	knowledge_base:terminalNode(N),
	node_coefficient(N, C), !.

infer(N, C) :-
	knowledge_base:terminalNode(N),
	knowledge_base:node(N, Name),
	nl, write('Введите степень уверенности от 0 до 1 для узла: '),
	write(Name), write('  '),
	read(R),
	C = R,
	assert(node_coefficient(N, R)).

infer(N, C) :-
	knowledge_base:implication(and, N, Np1, Np2, Sp1, Sp2, C1),
	infer_all_edges(Np1, Ctp1),
	infer_all_edges(Np2, Ctp2),
	sign(Ctp1, Sp1, Ctsp1),
	sign(Ctp2, Sp2, Ctsp2),
	take_min(Ctsp1, Ctsp2, Y),
	C is C1 * Y.

infer(N, C) :-
	knowledge_base:implication(or, N, Np1, Np2, Sp1, Sp2, C1),
	infer_all_edges(Np1, Ctp1),
	infer_all_edges(Np2, Ctp2),
	sign(Ctp1, Sp1, Ctsp1),
	sign(Ctp2, Sp2, Ctsp2),
	take_max(Ctsp1, Ctsp2, Y),
	C is C1 * Y.

infer(N, C) :-
	knowledge_base:implication(simple, N, Np1, dummy, Sp1, dummy, _),
	infer_all_edges(Np1, Ctp1),
	sign(Ctp1, Sp1, Ctsp1),
	C is Ctsp1.

sign(X, pos, X) :- !.
sign(X, neg, Y) :-
	Y is 1 - X, !.

take_min(X1, X2, Y) :-
	X1 < X2, Y = X1, !.
take_min(X1, X2, Y) :-
	X1 >= X2, Y = X2, !.


take_max(X1, X2, Y) :-
	X1 > X2, Y = X1, !.
take_max(X1, X2, Y) :-	
	X1 =< X2, Y = X2, !.


supercombine([], 0).
supercombine([C], C) :- !.
supercombine([C1, C2 | []], C) :-
	combine([C1, C2], C), !.
supercombine([C1, C2 | T], C) :-
	combine([C1, C2], Ct1),
	append([Ct1], T, T1),
	supercombine(T1, C), !.

combine([P1, P2], P) :-
	P is P1 + P2 - P1 * P2.
show_results :-
	not(show_r).
show_r :-
	answer(N, C),
	nl, write(N), write('   '), write(C),
	fail.


?- solver.

