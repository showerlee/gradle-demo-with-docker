#!/bin/sh -e

HOST=$1
PORT=$2
PROJECT=$3

curl -Is http://$HOST:$PORT/$PROJECT/ > /dev/null && echo "The remote side is healthy" || echo "The remote side is failed, please check"
