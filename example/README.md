Kerberos Kafka Brod Setup
-------------------------

## Acknowledgment

* Some of the code in this repo is copied from https://github.com/Accenture/reactive-interaction-gateway/tree/kafka-sasl-kerberos-authentication/examples/api-gateway/kafka-kerberos (which gives credits to [Dabz/kafka-security-playbook](https://github.com/Dabz/kafka-security-playbook/tree/master/kerberos))


## How to Use

Set up Kerberos, Zookeeper and Kafka in Docker containers:

```shell
./up
```

Test that everything is working after running `./up`:

```shell
./test_send_receive.sh
```

Run `brod_gssapi` client that sends and receive message (currently broken) (you need to run `./up` first):

```shell
docker-compose up brod_client
```

Stop Docker containers:

```shell
./down
```

