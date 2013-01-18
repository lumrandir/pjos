:- module(listener, [ ]).
:- use_module(library(socket)).
:- use_module(solver_additional).
:- encoding(utf8).

% форсированно закрывает связанные с сокетом потоки
close_connection(In, Out) :-
  close(In, [ force(true) ]),
  close(Out, [ force(true) ]).

% мониторит открытый сокет и создаёт потоки в случае подключения к нему клиента
dispatch(AcceptFd) :-
  % принимаем подключение
  tcp_accept(AcceptFd, Socket, _Peer),
  % при подключении создаём новый подпроцесс, который будет обрабатывать
  % эту сессию
  fork(Pid),
  (
      Pid == child
  ->  tcp_open_socket(Socket, In, Out), % открываем входной и выходной потоки
      % устанавливаем кодировку для потоков и делам их потоками по умолчанию
      set_stream(In, encoding(utf8)),
      set_stream(Out, encoding(utf8)),
      set_prolog_IO(In, Out, Out),
      % при сбое обработки закрываем потоки и останавливаем подпроцесс
      catch(
        handle_service, 
        _E, 
        (
          close_connection(In, Out), 
          halt, tcp_close_socket(Socket)
        )
      ),
      close_connection(In, Out),
      halt
  ;   tcp_close_socket(Socket)
  ),
  dispatch(AcceptFd).

% запускает солвер
handle_service :-
  solver_additional:run.

% управляет сокетом, связанным с портом
listen_tcp(Port) :-
  % создаём сокет
  tcp_socket(Socket),
  % привязываем сокет к порту, переданному в аргументе
  tcp_bind(Socket, Port),
  % начинаем слушать порт с максимальным числом подключений 5
  tcp_listen(Socket, 5),
  % открываем созданный сокет
  tcp_open_socket(Socket, AcceptFd, _),
  % рекурсивно обрабатываем подключения к сокету
  dispatch(AcceptFd).

?- listen_tcp(1337).
