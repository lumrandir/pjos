% This buffer is for notes you don't want to save.
% If you want to create a file, visit that file with C-x C-f,
% then enter the text in that file's own buffer.
:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/html_write)).
:- use_module(library(http/http_parameters)).
:- use_module(library(uri)).
:- use_module(library(http/http_files)).

:- http_handler(root(.), showWelcomePage,[]).
:- http_handler(root(node), showQuestionPage, []).
:- http_handler(root(save), saveData, []).
:- initialization
	http_server(http_dispatch, [port(5000)]).
?- server(5000).


:- dynamic danswer/2, dterm/2.

high(1000000).

low(100000).

node('1','спасаться!').
node('2','смириться').
node('3','Вы живете на Урале? ').
node('4','Вы нашли ковчег? ').
node('5','У вас неблагоприятные условия? ').
node('6','Меньше 500 км?').
node('7','Больше 500 км?').
node('8','Сколько у Вас денег? ').
node('9','У Вас есть связи? ').
node('10','Вы хитрый? ').
node('11','Выпадают аномальные осадки? ').
node('12','Почти нашли ковчег? ').


hyposnode('1').
hyposnode('2').

termnode('6').
termnode('7').
termnode('8').
termnode('9').
termnode('10').
termnode('11').



rule(and,'1','3','4',pos,pos,0.9).
rule(and,'2','4','5',neg,pos,0.9).
rule(or,'3','6','7',pos,pos,0.9).
rule(and,'12','8','9',pos,pos,1.0).
rule(and,'4','12','10',pos,pos,0.9).
rule(and,'5','7','11',pos,pos,0.9).

%--------------------------------------------------------------
showWelcomePage(_Request) :-
	purgateVirt,!,
        reply_html_page(title('Hello'),
                        [ h1('Armagedon welcome you'),
                          p(\startLink('6'))
                        ]).
showQuestionPage(Request):-
	http_parameters(Request,
                        [ num(Node, [])
                        ]),
	node(Node,Name),
	reply_html_page(title('Question'),
                        [ h1(Name),
			 % form(action('saveData'), method('get')),
			  b('Узел:'),
			  span(name('node'),Node),
			  br(/),
			  b('Ответ:'),
			  input([name('answer'),type('text')]),
			  br(/),
			  input(type('submit'))
                        ]).
startLink(H) -->
        { http_link_to_id(showQuestionPage, [num=H], HREF) },
        html(a(href(HREF),'start!')).
saveData(Request):-
	http_parameters(Request,
                        [ node(Node, []),
			  answer(Answer, [])
			]),
	hyposnode(Node),
        allinfer(Node,Answer),
	assert(danswer(Node,Answer)).
	.
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
/*
check(N,M,Ct):-
	termnode(N),
	high(H),
	low(L),
	M<H,
	M>L,
	Ct =  0.9,!.

check(N,M,Ct):-
	termnode(N),
	high(H),
	low(L),
	M>H,
	M<L,
	Ct = 0 ,!.

check(N,M,Ct):-
	termnode(N),
	M='да',
	Ct =  0.9,!.

check(N,M,Ct):-
	termnode(N),
	M='нет',
	Ct = 0 ,!.*/

infer(N,Ct):-
	termnode(N),
	dterm(N,Ct),!.

infer(N,Ct):-
	termnode(N),
	node(N,Name),
	write(Name),
	read(Ct),
	%check(N,R,Ct),
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
	nl,write('Вам нужно  '),write(Name),
	nl,write('Вероятность='),write(Ct).



%?- run.




