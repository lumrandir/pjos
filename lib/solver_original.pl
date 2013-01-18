% This buffer is for notes you don't want to save.
% If you want to create a file, visit that file with C-x C-f,
% then enter the text in that file's own buffer.
:- module(solver_original, []).
:- dynamic danswer/2, dterm/2.

/*high(1000000).

low(100000).*/

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

run:-
	purgateVirt,!,
%	test,!,
	getAllAnswers,!,
	showResults,!,
	nl,write('Ok, bye!').

%purgateVirt:- nl,write('Это - purgateVirt'),nl. %RTTI
purgateVirt:-
	    retractall(danswer(_,_)),
	    retractall(dterm(_,_)).

%test:-
%	assert(dterm(3,0.75)),
%	assert(dterm(4,0.9)),
%	assert(dterm(5,0.2)),
%	assert(dterm(6,0.55)),
%	assert(dterm(7,0.99)),
%	assert(dterm(8,0.45)),
%	assert(dterm(9,0.34)),
%	assert(dterm(10,0.89)),
%	assert(dterm(11,0.67)).
%	assert(dterm(12,1)).
getAllAnswers:- not(getAllAnswers2).



getAllAnswers2:- answer,fail.


answer:-
	 hyposnode(N),
	 allinfer(N,Ct),
	 assert(danswer(N,Ct)).

allinfer(N,Ct):-
	findall(X,infer(N,X),Ls),
	supercombine(Ls,Ct).


infer(N,Ct):-
	termnode(N),
	dterm(N,Ct),!.


infer(N,Ct):-
	termnode(N),
	node(N,Name),
	write(Name),
	read(Ct),
	assert(dterm(N,Ct)).

infer(N,Ct):-
	rule(and,N,Np1,Np2,Sp1,Sp2,C1),
	allinfer(Np1,Ctp1),
	allinfer(Np2,Ctp2),
	sign(Ctp1,Sp1,Ctsp1),
	sign(Ctp2,Sp2,Ctsp2),
	min2(Ctsp1,Ctsp2,Ctmin),
	Ct is Ctmin*C1.
infer(N,Ct):-
	rule(or,N,Np1,Np2,Sp1,Sp2,C1),
	allinfer(Np1,Ctp1),
	allinfer(Np2,Ctp2),
	sign(Ctp1,Sp1,Ctsp1),
	sign(Ctp2,Sp2,Ctsp2),
	max2(Ctsp1,Ctsp2,Ctmax),
	Ct is Ctmax*C1.

infer(N,Ct):-
	rule(simple,N,Np1,_,Sp1,_,C1),
	allinfer(Np1,Ctp1),
	sign(Ctp1,Sp1,Ctsp1),
	Ct is Ctsp1*C1.
%sign(Ctp,Sp,Ctp).

%sign(Ctp,Sp,Ctp1):-	Sp='pos',	Ctp1 is Ctp,!.
%sign(Ctp,Sp,Ctp1):-	Sp='neg',	Ctp1 is 1 - Ctp,!.

sign(X,'pos',X).
sign(X,'neg',Z):- Z is 1 - X,!.

%min2(X,Y,X).

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

%supercombine(Ls,0.7).

supercombine([Ct],Ct):-!.
supercombine([C1,C2],Ct):-
	combine([C1,C2],Ct),!.
supercombine([C1,C2|Ts],Ct):-
	combine([C1,C2],Ct1),
	append([Ct1],Ts,T1s),
	supercombine(T1s,Ct).
combine([C1,C2],Ct):-Ct is C1+C2-C1*C2.

%showResults:- nl,write('Это - showResults'). %RTTI

showResults:- not(showResults2).

showResults2:- result,fail.
result:-

	danswer(N,Ct),
	node(N,Name),
	nl,write('Следует  '),write(Name),
	nl,write('Вероятность='),write(Ct).

