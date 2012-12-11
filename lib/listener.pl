:- module(listener, []).
:- use_module(library(socket)).
:- use_module(library(streampool)).

listen_udp(Port) :-
  udp_socket(S),
  tcp_bind(S, Port),
  repeat,
  udp_receive(S, Data, From, [as(atom)]),
  format('Got ~q from ~q~n', [Data, From]),
  fail.

listen_tcp(Port) :-
  tcp_socket(Socket),
  tcp_bind(Socket, Port),
  tcp_listen(Socket, 5),
  tcp_open_socket(Socket, AcceptFd, _),
  dispatch(AcceptFd).

dispatch(AcceptFd) :-
  tcp_accept(AcceptFd, Socket, _Peer),
  tcp_open_socket(Socket, In, Out),
  read(In, Term),
  write(Term),
  close(In), close(Out),
  tcp_close_socket(Socket),
  dispatch(AcceptFd).

?- listen_tcp(1337).

