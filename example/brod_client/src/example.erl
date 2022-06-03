-module(example).

%% API exports
-export([main/1]).

%%====================================================================
%% API functions
%%====================================================================

%% escript Entry point
main(Args) ->
    io:format("Args: ~p~n", [Args]),
    {ok, _} = application:ensure_all_started(brod),
    KafkaBootstrapEndpoints = [{"kafka.kerberos-demo.local", 9093}],
    Topic = <<"test-topic">>,
    Partition = 0,
    KeyTab = <<"/var/lib/secret/rig.key">>,
    Principal = <<"rig@TEST.CONFLUENT.IO">>,
    Config = [{sasl, {callback, brod_gssapi_v1, {gssapi, KeyTab, Principal}}}],
    erlang:display({going_to_connect, KafkaBootstrapEndpoints}),
    ok = brod:start_client(KafkaBootstrapEndpoints, client1, Config),
    ok = brod:start_producer(client1, Topic, _ProducerConfig = []),
    {ok, FirstOffset} = brod:produce_sync_offset(client1, Topic, Partition, <<"FistKey">>, <<"FirstValue">>),
    ok = brod:produce_sync(client1, Topic, Partition, <<"Kjell">>, <<"Winblad">>),
    SubscriberCallbackFun = fun(_Partition, Msg, ShellPid = CallbackState) ->
                                    ShellPid ! Msg, {ok, ack, CallbackState}
                            end,
    Receive = fun() ->
                      receive
                          Msg -> Msg
                      after 1000 -> timeout
                      end
              end,
    brod_topic_subscriber:start_link(client1,
                                     Topic,
                                     _Partitions=[Partition],
                                     _ConsumerConfig=[{begin_offset, FirstOffset}],
                                     _CommittdOffsets=[], message, SubscriberCallbackFun,
                                     _CallbackState=self()),
    %AckCb = fun(Partition, BaseOffset) -> io:format(user, "\nProduced to partition ~p at base-offset ~p\n", [Partition, BaseOffset]) end,
    %ok = brod:produce_cb(client1, Topic, Partition, <<>>, [{<<"key3">>, <<"value3">>}], AckCb)
    timer:sleep(1000),
    erlang:display(Receive()),
    erlang:display(Receive()),
    erlang:halt(0).

%%====================================================================
%% Internal functions
%%====================================================================
