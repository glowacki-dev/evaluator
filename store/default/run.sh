#!/bin/bash

exec 1> /code/log
exec 2> /code/errors

START=$(date +%s.%2N)

$1 /code/$2

END=$(date +%s.%2N)

echo ${END} - ${START} | bc > /code/time
