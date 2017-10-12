#!/bin/bash

exec 1> /code/output
exec 2> /code/errors

START=$(date +%s%3N)

sudo -u executor $1 /code/$2 | head -c $3

END=$(date +%s%3N)

echo ${END} - ${START} | bc > /code/time
