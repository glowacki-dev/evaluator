#!/bin/bash

exec 1> /code/log
exec 2> /code/errors

START=$(date +%s%3N)

$1 /code/$2

END=$(date +%s%3N)

echo ${END} - ${START} | bc > /code/time
