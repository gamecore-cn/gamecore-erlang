%%%-------------------------------------------------------------------
%%% @author xiayiping@qq.com
%%% @copyright (C) 2021, Gamecore.cn MVC
%%% @doc
%%%
%%% @end
%%% Created : 09. 11月 2021 12:09
%%%-------------------------------------------------------------------
-module(icommand).
-author("xiayiping").
-include("common.hrl").
-include("srv.hrl").


%% callback
%%------------------------------------------------------------------
%% @doc
-callback execute(Notification :: #n{}) ->
    ?ok.
