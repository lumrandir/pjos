:- module(solver, []).
:- encoding(utf8).

% This buffer is for notes you don't want to save.
% If you want to create a file, visit that file with C-x C-f,
% then enter the text in that file's own buffer.

/*node(1,'Кредит одобрен').
node(2,'Кредит не одобрен').
node(3,'Надежный клиент').
node(4,'Клиент, прошедший по минимальным требованиям').
node(5,'Ненадежный клиент').
node(6,'Наличие трудового контракта, справка НДФЛ').
node(7,'Наличие дипломов о высшем образовании').
node(8,'Наличие трудового стажа более года').
node(9,'Документы на недвижимость').
node(10,'возраст от 20 до 45').
node(11,'наличие кредитных обязательств').
node(12,'гражданство РФ').
node(13,'наличие работы без трудоустройства').
node(14,'положительные документы').
node(15,'положительные данные').
hyposNode(1).
hyposNode(2).
termNode(6).
termNode(7).
termNode(8).
termNode(9).
termNode(10).
termNode(11).
termNode(12).
termNode(13).
imp(1,and,14,6,7,pos,pos,1).
imp(2,and,15,9,10,pos,pos,1).
imp(3,or,5,12,13,neg,pos,0.6).
imp(4,and,4,15,11,pos,pos,0.9).
imp(5,and,3,14,8,pos,pos,0.7).
imp(6,and,1,3,4,pos,neg,0.8).
imp(7,or,2,4,5,pos,pos,0.95).*/

node(1,'self-healing').
node(2,'call a doctor').
node(3,'flu').
node(4,'a group of risk').
node(5,'pharyngitis').
node(6,'heat').
node(7,'running nose').
node(8,'pain').
node(9,'younger than 3').
node(10,'older than 65').
node(11,'pain in the throat').
node(12,'hard to breathe').
node(13,'intermediate point').
node(14,'intermediate point 2').
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
imp(2,and,3,13,8,pos,pos,0.7).
imp(3,or,4,9,10,pos,pos,0.9).
imp(4,and,5,11,12,pos,pos,0.6).
imp(5,and,1,3,4,pos,neg,0.8).
imp(6,and,2,3,4,neg,pos,0.9).
%imp(7,or,2,14,5,pos,pos,0.95).
imp(7,simple,2,5,dummy,pos,dummy,0.95).
/*term_N_Ct(6,0.1).
term_N_Ct(7,0.9).
term_N_Ct(8,0.4).
term_N_Ct(9,0.01).
term_N_Ct(10,0.01).
term_N_Ct(11,0.01).
term_N_Ct(12,0.01).*/

/*node(0,'Максимизация прибыли').
node(1001,'Финансы и Клиенты').
node(1002,'Финансы, Клиенты и Внутреннее устройство').
node(1003,'Финансы, Клиенты, Внутреннее устройство и Обучение').
node(1,'Финансовая составляющая').
node(2,'Клиентская составляющая').
node(3,'Внутренняя составляющая').
node(4,'Составляющая обучения').
node(5,'Составляющая развития').
node(1011,'Повышение капитализации и финансовой устойчивости').
node(1012,'Повышение капитализации, финансовой устойчивости и эффективности управления').
node(1013,'Повышение капитализации, финансовой устойчивости, эффективности управления и привлечения инвестиций').
node(11,'Повышение капитализации банка').
node(12,'Повышение финансовой устойчивости').
node(13,'Повышение эффективности управления финансами').
node(14,'Привлечение инвестиций').
node(15,'Рост прибыли и оборота').
node(1021,'Оптимизация и повышение известности').
node(1022,'Оптимизация, повышение известности и комплексности обслуживания').
node(1023,'Оптимизация, повышение известности и комплексности обслуживания и удовлетворенности клиентов').
node(1024,'Оптимизация, повышение известности и комплексности обслуживания и удовлетворенности клиентов, привлечения клиентов').
node(1025,'Оптимизация, повышение известности и комплексности обслуживания и удовлетворенности клиентов, привлечения клиентов, создание Private Banking').
node(21,'Оптимизация линейки банковских продуктов и услуг').
node(22,'Повышение известности и репутации банка').
node(23,'Повышение комплексности обслуживания клиента').
node(24,'Повышение удовлетворенности клиентов и качества сервиса').
node(25,'Привлечение и удержание стратегических клиентов').
node(21,'Создание направления Private Bank').
node(21,'Увеличение доли рынка и количества клиентов').
node(1031,'Автоматизация БП и описание БП').
node(1032,'Автоматизация БП, описание БП и разработка БП').
node(31,'Автоматизация ключевых бизнес-процессов').
node(32,'Описание и оптимизация бизнес-процессов банка').
node(33,'Разработка бизнес-процессов для новых продуктов и услуг').
node(34,'Разработка новых внутренних бизнес-процессов').
node(1041,'Развитие страт. компетенций и привлечение ценных сотрудников').
node(1042,'Развитие страт. компетенций, привлечение ценных сотрудников и мотивирующие вознаграждения').
node(41,'Развитие стратегических компетенций').
node(42,'Привлечение и сохранение особо талантливых сотрудников').
node(43,'Мотивирующие вознаграждения').
node(44,'Обмен знаниями').
node(1051,'Выявление возможностей и управление портфелем исследований').
node(1052,'Выявление возможностей, управление портфелем исследований и проектирование новых продуктов').
node(51,'Выявление возможностей для создания новых продуктов и услуг').
node(52,'Управление портфелем исследований и разработок').
node(53,'Проектирование и развитие новых продуктов и услуг').
node(54,'Продвижение новых продуктов и услуг на рынок').
hyposNode(0).
termNode(11).
termNode(12).
termNode(13).
termNode(14).
termNode(15).
termNode(21).
termNode(22).
termNode(23).
termNode(24).
termNode(25).
termNode(26).
termNode(27).
termNode(31).
termNode(32).
termNode(33).
termNode(34).
termNode(41).
termNode(42).
termNode(43).
termNode(44).
termNode(51).
termNode(52).
termNode(53).
termNode(54).
imp(1,and,1001,1,2,pos,pos,1).
imp(2,and,1002,1001,3,pos,pos,1).
imp(3,and,1003,1002,4,pos,pos,1).
imp(4,and,0,1003,5,pos,pos,0.95).

imp(5,and,1011,11,12,pos,pos,1).
imp(6,and,1012,1011,13,pos,pos,1).
imp(7,and,1013,1012,14,pos,pos,1).
imp(8,and,1,1013,15,pos,pos,0.9).

imp(9,and,1021,21,22,pos,pos,1).
imp(10,and,1022,1021,23,pos,pos,1).
imp(11,and,1023,1022,24,pos,pos,1).
imp(12,and,1024,1023,25,pos,pos,1).
imp(13,and,1025,1024,26,pos,pos,1).
imp(14,and,2,1025,27,pos,pos,0.9).

imp(15,and,1031,31,32,pos,pos,1).
imp(16,and,1032,1031,33,pos,pos,1).
imp(17,and,3,1032,34,pos,pos,0.9).

imp(18,and,1041,41,42,pos,pos,1).
imp(19,and,1042,1041,43,pos,pos,1).
imp(20,and,4,1042,44,pos,pos,0.9).

imp(21,and,1051,51,52,pos,pos,1).
imp(22,and,1052,1051,53,pos,pos,1).
imp(23,and,5,1052,54,pos,pos,0.9).

term_N_Ct(11,0.9).
term_N_Ct(12,0.87).
term_N_Ct(13,0.9).
term_N_Ct(14,0.9).
term_N_Ct(15,0.87).
term_N_Ct(21,0.9).
term_N_Ct(22,0.91).
term_N_Ct(23,0.9).
term_N_Ct(24,0.87).
term_N_Ct(25,0.88).
term_N_Ct(26,0.9).
term_N_Ct(27,0.92).
term_N_Ct(31,0.9).
term_N_Ct(32,0.92).
term_N_Ct(33,0.9).
term_N_Ct(34,0.89).
term_N_Ct(41,0.91).
term_N_Ct(42,0.9).
term_N_Ct(43,0.85).
term_N_Ct(44,0.9).
term_N_Ct(51,0.89).
term_N_Ct(52,0.9).
term_N_Ct(53,0.94).
term_N_Ct(54,0.9).*/



:- dynamic
	dans/2,
	dnodecoeff/2.

solver(In, Out):-
	purgateVirt,
	get_all_answers(In, Out),
	showResults,
	nl, write('Ok, bye!'),!.


purgateVirt:-
	retractall(dans(_,_)),
	retractall(dnodecoeff(_,_)).

get_all_answers(In, Out):-
		not(get_all_answer(In, Out)).

get_all_answer(In, Out):-
	        answer(In, Out),
		fail.
answer(In, Out):-
	hyposNode(N),
%	spy(all_infer),
	all_infer(N,Ct, In, Out),
%	nospy(all_infer),
	assert(dans(N,Ct)).

% all_infer(_,0.8).

all_infer(N,Ct, In, Out):-
	findall(X,infer(N,X, In, Out),Ls),
	nl,write('Ls='),write(Ls),
	supercombine(Ls,Ct).


infer(N,Ct, In, Out):-
	termNode(N),
	dnodecoeff(N,Ct),!.
infer(N,Ct, In, Out):-
	termNode(N),
	node(N,Name),
        format(Out, 'Enter the assurance level for ~q~n', [ Name ]),
        flush_output(Out),
	(
	  at_end_of_stream(In)
	-> !
	; read_pending_input(In, String, []),
	  string_to_atom(String, R)
	),
	Ct=R,
	assert(dnodecoeff(N,R)).
infer(N,Ct, In, Out):-
	imp(No,and,N,Np1,Np2,Sp1,Sp2,C1),
	all_infer(Np1,Ctp1, In, Out),
	all_infer(Np2,Ctp2, In, Out),
	sign(Ctp1,Sp1,Ctsp1),
	sign(Ctp2,Sp2,Ctsp2),
	min1(Ctsp1,Ctsp2,Y),
	Ct is C1*Y.
infer(N,Ct, In, Out):-
	imp(No,or,N,Np1,Np2,Sp1,Sp2,C1),
	all_infer(Np1,Ctp1, In, Out),
	all_infer(Np2,Ctp2, In, Out),
	sign(Ctp1,Sp1,Ctsp1),
	sign(Ctp2,Sp2,Ctsp2),
	max1(Ctsp1,Ctsp2,Y),
	Ct is C1*Y.
infer(N,Ct, In, Out):-
	imp(No,simple,N,Np1,dummy,Sp1,dummy,C1),
	all_infer(Np1,Ctp1, In, Out),
	sign(Ctp1,Sp1,Ctsp1, In, Out),
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
	nl, write(N), write('   '), write(Ct),
	fail.

