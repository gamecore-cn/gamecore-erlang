%%%-------------------------------------------------------------------
%%% @author xiayiping@qq.com
%%% @copyright (C) 2021, Gamecore.cn MVC
%%% @doc
%%%
%%% @end
%%% Created : 09. 11月 2021 14:52
%%%-------------------------------------------------------------------
-module(eutil).
-author("xiayiping").
-include("common.hrl").

-export([
    to_atom/1,
    to_list/1,
    to_string/1,
    to_binary/1,
    to_integer/1,
    to_float/1,

    module_exist/1,
    is_string/1,
    compare_as_list/2,
    compare_as_string/2,
    compare_as_atom/2,
    compare_as_integer/2,
    compare_as_binary/2
]).


%% @doc
%% Convert the given term to atom
%%
%% Example:
%% <pre>
%% atom = eutils:to_atom(atom).
%% atom = eutils:to_atom(&lt;&lt;"atom"&gt;&gt;).
%% atom = eutils:to_atom("atom").
%% </pre>
%% @end
to_atom(X) when is_atom(X) ->
    X;
to_atom(X) when is_binary(X); is_bitstring(X) ->
    binary_to_atom(X, utf8);
to_atom(X) when is_list(X) ->
    list_to_atom(X).

%% @doc
%% Convert the given term to list
%%
%% 使用例子:
%% <pre>
%% "list" = eutils:to_list(list).
%% "list" = eutils:to_list("list").
%% "list" = eutils:to_list(&lt;&lt;"list"&gt;&gt;).
%% "123" = eutils:to_list(123).
%% "1.20000000000000000000e+01" = eutils:to_list(12.0).
%% "true" = eutils:to_list(true).
%% "false" = eutils:to_list(false).
%% </pre>
%% @end
to_list(V) when is_atom(V) ->
    atom_to_list(V);
to_list(V) when is_list(V) ->
    V;
to_list(V) when is_integer(V) ->
    integer_to_list(V);
to_list(V) when is_float(V) ->
    float_to_list(V);
to_list(V) when is_binary(V); is_bitstring(V) ->
    binary_to_list(V);
to_list(V) when is_tuple(V) ->
    [element(I, V) || I <- lists:seq(1, tuple_size(V))];
to_list(true) ->
    "true";
to_list(false) ->
    "false".

%% @doc
%% Convert the given term to string
%% @end
to_string(V) ->
    lists:flatten(to_list(V)).

%% @doc
%% Convert the given term to binary
%%
%% 使用例子:
%% <pre>
%% &lt;&lt;"list"&gt;&gt; = eutils:to_binary(list).
%% &lt;&lt;"list"&gt;&gt; = eutils:to_binary("list").
%% &lt;&lt;"list"&gt;&gt; = eutils:to_binary(&lt;&lt;"list"&gt;&gt;).
%% &lt;&lt;"123"&gt;&gt; = eutils:to_binary(123).
%% &lt;&lt;"1.20000000000000000000e+01"&gt;&gt; = eutils:to_binary(12.0).
%% &lt;&lt;"true"&gt;&gt; = eutils:to_binary(true).
%% &lt;&lt;"false"&gt;&gt; = eutils:to_binary(false).
%% </pre>
%% @end
to_binary(V) when is_binary(V); is_bitstring(V) ->
    V;
to_binary(V) ->
    iolist_to_binary(to_list(V)).

%% @doc
%% Convert the given term to integer
%%
%% 使用例子
%%<pre>
%% 123 = eutils:to_integer(123).
%% 123 = eutils:to_integer("123").
%% 123 = eutils:to_integer(<<"123">>).
%% 123 = eutils:to_integer('123').
%% 123 = eutils:to_integer(123.456).
%% </pre>
%% @end
to_integer(I) when is_integer(I) ->
    I;
to_integer(I) when is_list(I) ->
    try
        list_to_integer(I)
    catch _:_:_ ->
        round(list_to_float(I))
    end;
to_integer(I) when is_list(I) ->
    try
        binary_to_integer(I)
    catch _:_:_ ->
        round(binary_to_float(I))
    end;
to_integer(I) when is_atom(I) ->
    to_integer(atom_to_list(I));
to_integer(I) when is_float(I) ->
    to_integer(float_to_list(I, [{decimals, 0}])).

%% @doc
%% Convert the given term to float
%%
%% 使用例子
%%<pre>
%% 123.45 = eutils:to_float(123.45).
%% 123.45 = eutils:to_float("123.45").
%% 123.45 = eutils:to_float(<<"123.45">>).
%% 123.45 = eutils:to_float('123.45').
%% 123.0 = eutils:to_float(123).
%% </pre>
%% @end
to_float(Value) when is_integer(Value) ->
    float(Value);
to_float(Value) when is_float(Value) ->
    Value;
to_float(Value) when is_list(Value) ->
    case string:to_float(Value) of
        {error, no_float} -> float(list_to_integer(Value));
        {F, _} -> F
    end;
to_float(Value) when is_binary(Value) ->
    to_float(binary_to_list(Value));
to_float(Value) when is_atom(Value) ->
    to_float(atom_to_list(Value)).

%% @doc
%% Check if the given module exist
%% @end
module_exist(Module) ->
    case is_atom(Module) of
        true ->
            try Module:module_info() of
                _InfoList ->
                    true
            catch
                _:_ ->
                    false
            end;
        false ->
            false
    end.

%% @doc
%% Check if the given value is a string
%% @end
is_string(V) when is_list(V) ->
    io_lib:printable_list(V) orelse io_lib:printable_latin1_list(V) orelse io_lib:printable_unicode_list(V);
is_string(_) -> false.

compare_as_list(V1, V2) ->
    compare_as(fun to_list/1, V1, V2).
compare_as_string(V1, V2) ->
    compare_as(fun to_string/1, V1, V2).
compare_as_atom(V1, V2) ->
    compare_as(fun to_atom/1, V1, V2).
compare_as_integer(V1, V2) ->
    compare_as(fun to_integer/1, V1, V2).
compare_as_binary(V1, V2) ->
    compare_as(fun to_binary/1, V1, V2).

compare_as(Fun, V1, V2) ->
    V11 = Fun(V1), V21 = Fun(V2),
    if
        V11 < V21 -> -1;
        V11 =:= V21 -> 0;
        ?true -> 1
    end.