-module(brod_gssapi_v1_SUITE).

-compile(export_all).
-include_lib("common_test/include/ct.hrl").
-include_lib("eunit/include/eunit.hrl").

%%%%%%%%%%%%%%%%%%
%%%  CT hooks  %%%
%%%%%%%%%%%%%%%%%%

all() ->
    [
     foo
    ].

init_per_suite(Config) ->
    meck:new([sasl_auth, inet, ssl, kpro_req_lib, kpro_lib, kpro], [passthrough, no_link, unstick]),
    Config.

end_per_suite(Config) ->
    meck:unload([sasl_auth, inet, ssl, kpro_req_lib, kpro_lib, kpro]),
    Config.

init_per_testcase(_Tc, Config) ->
    Config.

end_per_testcase(_Tc, Config) ->
    reset_mocks([sasl_auth, inet, ssl, kpro_req_lib, kpro_lib, kpro]),
    Config.

foo(_Config) ->
    ok.

%%%%%%%%%%%%%%%%%%
%%%  Helpers   %%%
%%%%%%%%%%%%%%%%%%

reset_mocks(Modules) ->
    meck:reset(Modules),
    [meck:delete(Module, Fun, Arity, false)
     || {Module, Fun, Arity} <- meck:expects(Modules, true)].
