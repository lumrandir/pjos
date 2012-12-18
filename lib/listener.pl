:- module(listener, []).
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
      handle_service(In, Out),
      close_connection(In, Out),
      halt
  ;   tcp_close_socket(Socket)
  ),
  dispatch(AcceptFd).

handle_service(In, Out) :-
  solver:solver(In, Out).
%  repeat,
%    (
%        at_end_of_stream(In)
%    ->  !
%    ;   read_pending_input(In, String, []),
%        string_to_atom(String, Atom),
%        format(Out, '~q~n', [ Atom ]),
%        flush_output(Out),
%        fail
%    ).

listen_tcp(Port) :-
  tcp_socket(Socket),
  tcp_bind(Socket, Port),
  tcp_listen(Socket, 5),
  tcp_open_socket(Socket, AcceptFd, _),
  dispatch(AcceptFd).

listen_udp(Port) :-
  udp_socket(S),
  tcp_bind(S, Port),
  repeat,
  udp_receive(S, Data, From, [ as(atom) ]),
  format('Got ~q from ~q~n', [ Data, From ]),
  fail.

?- listen_tcp(1339).

