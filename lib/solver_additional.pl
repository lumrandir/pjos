% This buffer is for notes you don't want to save.
% If you want to create a file, visit that file with C-x C-f,
% then enter the text in that file's own buffer.
:- module(solver_additional, []).

node(1,'лечится самостоятельно').
node(2,'вызвать врача').
node(3,'грипп').
node(4,'группа риска').
node(5,'острый фарингит').
node(6,'температура').
node(7,'насморк').
node(8,'ломота в теле').
node(9,'моложе 3х лет').
node(10,'старше 65 лет').
node(11,'болит горло').
node(12,'трудно дышать').
node(13,'промежутоный пункт').
node(14,'промежуточный пункт2').
hyposNode(1).
hyposNode(2).
termNode(6).
termNode(7).
termNode(8).
termNode(9).
termNode(10).
termNode(11).
termNode(12).
imp(1,and,13,6,7,pos,pos,1).
imp(2,and,3,13,8,pos,pos,0.9).
imp(3,or,4,9,10,pos,pos,0.9).
imp(4,and,5,11,12,pos,pos,0.9).
imp(5,and,1,3,4,pos,neg,0.9).
imp(6,and,2,3,4,neg,pos,0.9).
imp(7,simple,2,5,dummy,pos,dummy,0.95).


:- dynamic
	dans/2,
	dnodecoeff/2.

run:-
	purgateVirt,
	get_all_answers,
	showResults,
	nl, write('Ok, bye!'),!.


purgateVirt:-
	retractall(dans(_,_)),
	retractall(dnodecoeff(_,_)).

get_all_answers:-
		not(get_all_answer).

get_all_answer:-
	        answer,
		fail.
answer:-
	hyposNode(N),
	all_infer(N,Ct),
	assert(dans(N,Ct)).

all_infer(N,Ct):-
	findall(X,infer(N,X),Ls),
%	nl,write('Ls='),write(Ls),
	supercombine(Ls,Ct).

infer(N,Ct):-
	termNode(N),
	dnodecoeff(N,Ct),!.
infer(N,Ct):-
	termNode(N),
	node(N,Name),
	nl,write('Введите степень уверенности от 0 до 1 для узла: '),
	write(Name),write('  '),
	read(R),
	Ct=R,
	assert(dnodecoeff(N,R)).
infer(N,Ct):-
	imp(No,and,N,Np1,Np2,Sp1,Sp2,C1),
	all_infer(Np1,Ctp1),
	all_infer(Np2,Ctp2),
	sign(Ctp1,Sp1,Ctsp1),
	sign(Ctp2,Sp2,Ctsp2),
	min1(Ctsp1,Ctsp2,Y),
	Ct is C1*Y.
infer(N,Ct):-
	imp(No,or,N,Np1,Np2,Sp1,Sp2,C1),
	all_infer(Np1,Ctp1),
	all_infer(Np2,Ctp2),
	sign(Ctp1,Sp1,Ctsp1),
	sign(Ctp2,Sp2,Ctsp2),
	max1(Ctsp1,Ctsp2,Y),
	Ct is C1*Y.
infer(N,Ct):-
	imp(No,simple,N,Np1,dummy,Sp1,dummy,C1),
	all_infer(Np1,Ctp1),
	sign(Ctp1,Sp1,Ctsp1),
	Ct is Ctsp1.
sign(X,pos,X):- !.
sign(X,neg,Y):-
	Y is 1-X,!.

min1(X1,X2,Y):-	X1<X2, Y=X1,!.
min1(X1,X2,Y):-	X1>=X2, Y=X2,!.


max1(X1,X2,Y):-	X1>X2,	Y=X1,!.
max1(X1,X2,Y):-	X1=<X2,	Y=X2,!.


supercombine([],0).
supercombine([Ct],Ct):-!.
supercombine([C1,C2|[]],Ct):-
	combine([C1,C2],Ct),!.
supercombine([C1,C2|Ts],Ct):-
	combine([C1,C2],Ct1),
	append([Ct1],Ts,T1s),
	supercombine(T1s,Ct),!.


combine([P1,P2],P):-
	P is P1+P2-P1*P2.
showResults:-
	not(showR).
showR:-
	dans(N,Ct),
	node(N,Name),
	nl, write('Вероятность что необходимо '),write(Name), write('   '), write(Ct),
	fail.
