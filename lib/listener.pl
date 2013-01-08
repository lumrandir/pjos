:- module(listener, [ ]).
:- use_module(library(socket)).
:- use_module(solver).
:- encoding(utf8).

close_connection(In, Out) :-
  close(In, [ force(true) ]),
  close(Out, [ force(true) ]).

dispatch(AcceptFd) :-
  tcp_accept(AcceptFd, Socket, _Peer),
  fork(Pid),
  (
      Pid == child
  ->  tcp_open_socket(Socket, In, Out),
      set_stream(In, encoding(utf8)),
      set_stream(Out, encoding(utf8)),
      catch(handle_service(In, Out), E, (print_message(error, E), close_connection(In, Out), halt, tcp_close_socket(Socket))),
      close_connection(In, Out),
      halt
  ;   tcp_close_socket(Socket)
  ),
  dispatch(AcceptFd).

handle_service(In, Out) :-
  solver:run(In, Out).

listen_tcp(Port) :-
  tcp_socket(Socket),
  tcp_bind(Socket, Port),
  tcp_listen(Socket, 5),
  tcp_open_socket(Socket, AcceptFd, _),
  dispatch(AcceptFd).

?- listen_tcp(1337).
