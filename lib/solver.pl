:- module(solver, [ run/2 ]).
:- dynamic danswer/2, dterm/2.

node(1,'снять с учета').
node(2,'продолжить реабилитацию').
node(3,'пригласить на прием').
node(4,'легкая степень/контрольная явка 2 года').
node(5,'положительная динамика/контрольная явка больше 2 лет').
node(6,'контрольная явка больше 2 лет/отрицательная динамика').
node(7,'легкая степень/контрольная явка больше 2 лет').
node(8,'средняя степень/контрольная явка больше 2 лет').
node(9,'контрольная явка больше 2 лет/тяжелая степень').
node(10,'здоров?').
node(11,'Легкая степень?').
node(12,'Положительная динамика?').
node(13,'Средняя степень?').
node(14,'Контрольная явка больше 2 лет?').
node(15,'Тяжелая степень?').


hyposnode(1).
hyposnode(2).
hyposnode(3).


termnode(10).
termnode(11).
termnode(12).
termnode(13).
termnode(14).
termnode(15).



rule(or,1,10,4,pos,pos,0.95).
rule(and,2,10,14,neg,neg,0.95).
rule(or,3,6,9,pos,pos,0.95).
rule(or,4,7,5,pos,pos,0.95).
rule(and,7,11,14,pos,pos,0.95).
rule(and,5,12,8,pos,pos,0.95).
rule(and,6,12,8,neg,pos,0.95).
rule(and,8,13,14,pos,pos,0.95).
rule(and,9,14,15,pos,pos,0.95).


%--------------------------------------------------------------

run(In, Out):-
	purgateVirt,!,
	getAllAnswers(In, Out),!,
	showResults(Out),!,
  flush_output(Out).

purgateVirt:-
	    retractall(danswer(_,_)),
	    retractall(dterm(_,_)).

getAllAnswers(In, Out):- not(getAllAnswers2(In, Out)).

getAllAnswers2(In, Out):- answer(In, Out),fail.

answer(In, Out):-
	 hyposnode(N),
	 allinfer(N,Ct, In, Out),
	 assert(danswer(N,Ct)).

allinfer(N,Ct, In, Out):-
	findall(X,infer(N,X, In, Out),Ls),
	supercombine(Ls,Ct).

infer(N,Ct, _In, _Out):-
	termnode(N),
	dterm(N,Ct),!.

infer(N,Ct, In, Out):-
	termnode(N),
	node(N,Name),
  format(Out, '~q~n', [ Name ]),
  flush_output(Out),
  ( 
    at_end_of_stream(In)
  ->
    fail;
    read_pending_input(In, String, []),
    string_to_atom(String, Atom),
    atom_number(Atom, Ct)
  ),
	assert(dterm(N,Ct)).

infer(N,Ct, In, Out):-
	rule(and,N,Np1,Np2,Sp1,Sp2,C1),
	allinfer(Np1,Ctp1, In, Out),
	allinfer(Np2,Ctp2, In, Out),
	sign(Ctp1,Sp1,Ctsp1),
	sign(Ctp2,Sp2,Ctsp2),
	min2(Ctsp1,Ctsp2,Ctmin),
	Ct is Ctmin*C1.

infer(N,Ct, In, Out):-
	rule(or,N,Np1,Np2,Sp1,Sp2,C1),
	allinfer(Np1,Ctp1, In, Out),
	allinfer(Np2,Ctp2, In, Out),
	sign(Ctp1,Sp1,Ctsp1),
	sign(Ctp2,Sp2,Ctsp2),
	max2(Ctsp1,Ctsp2,Ctmax),
	Ct is Ctmax*C1.

infer(N,Ct, In, Out):-
	rule(simple,N,Np1,_,Sp1,_,C1),
	allinfer(Np1,Ctp1, In, Out),
	sign(Ctp1,Sp1,Ctsp1),
	Ct is Ctsp1*C1.

sign(X,'pos',X).
sign(X,'neg',Z):- Z is 1 - X,!.

min2(Ctsp1,Ctsp2,Ctmin):-
	Ctsp1>=Ctsp2,
	Ctmin is Ctsp2,!.
min2(Ctsp1,Ctsp2,Ctmin):-
	Ctsp2>Ctsp1,
	Ctmin is Ctsp1,!.

max2(Ctsp1,Ctsp2,Ctmax):-
	Ctsp1>=Ctsp2,
	Ctmax is Ctsp1,!.
max2(Ctsp1,Ctsp2,Ctmax):-
	Ctsp2>Ctsp1,
	Ctmax is Ctsp2,!.

supercombine([Ct],Ct):-!.
supercombine([C1,C2],Ct):-
	combine([C1,C2],Ct),!.
supercombine([C1,C2|Ts],Ct):-
	combine([C1,C2],Ct1),
	append([Ct1],Ts,T1s),
	supercombine(T1s,Ct).
combine([C1,C2],Ct):-Ct is C1+C2-C1*C2.

showResults(Out):- not(showResults2(Out)).

showResults2(Out):- result(Out),fail.
result(Out):-
	danswer(N,Ct),
	node(N,Name),
  format(Out, 'Следует ~q~n', [ Name ]),
  flush_output(Out),
  format(Out, 'Вероятность=~q~n', [ Ct ]),
  flush_output(Out).

