#!/bin/sh

#sleep infinity


# docker-compose build

# ./setup-test-env.sh
sleep 7
rebar3 clean
rebar3 compile

erl -noshell `rebar3 path | xargs -n1 echo -pa | tr '\n' ' '` -eval 'example:main([])'


# docker-compose down
