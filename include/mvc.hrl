%%%-------------------------------------------------------------------
%%% @author xiayiping@qq.com
%%% @copyright (C) 2021, Gamecore.cn MVC
%%% @doc
%%%
%%% @end
%%% Created : 09. 11月 2021 12:18
%%%-------------------------------------------------------------------
-author("xiayiping").
-ifndef(__mvc__hrl).
-define(__mvc__hrl, true).

%%% define
%%% -------------------------------------------------------------------



%%% record
%%% -------------------------------------------------------------------
%% 通知
-record(i_notification, {
    name ::atom()       % 名称
    , body :: term()    % 通知内容
    , type :: integer() % 类型
}).

-endif.