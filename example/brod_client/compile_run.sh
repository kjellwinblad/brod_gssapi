#!/bin/sh

#sleep infinity

rebar3 clean
rebar3 compile

erl -noshell `rebar3 path | xargs -n1 echo -pa | tr '\n' ' '` -eval 'example:main([])'

