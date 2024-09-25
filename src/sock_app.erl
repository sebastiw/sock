-module(sock_app).

-behaviour(application).

%% API
-export([]).

%% Application
-export([start/2,
         stop/1
        ]).

%% ---------------------------------------------------------------------------
%% API
%% ---------------------------------------------------------------------------

%% ---------------------------------------------------------------------------
%% Application
%% ---------------------------------------------------------------------------

-spec start(_, _) -> {ok, pid()}.
start(_, _) ->
  sock_sup:start_link().

-spec stop(_) -> ok.
stop(_) ->
  ok.