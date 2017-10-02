#!/bin/bash

# Input: uuid runner
# Available runners: ruby python python3 nodejs

exec 2> /dev/null

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
STORE="${ROOT}/store"
MACHINE="${STORE}/${1}"
CODE="${STORE}/code/${1}"

mkdir ${MACHINE} && cp ${STORE}/default/* ${MACHINE}
cp ${CODE} ${MACHINE}/code
chmod 744 -R ${MACHINE}

MACHINE_ID=$(docker run -d --read-only --memory=40m --cpus=0.25 -v ${MACHINE}:/code compiler_machine /code/run.sh ${2} code)

# Because executor user doesn't have write access, so the only file that will be created is `time`
# This file is created at the very end of our script, so we use it to know when we're done
# It's also possible to do it with `docker wait` and timeout, but it was about 100ms slower
if inotifywait -t 5 -qq -e create ${MACHINE}; then
    cat ${MACHINE}/time
else
    echo "-1"
fi

echo "*****"
cat ${MACHINE}/log
echo "*****"
cat ${MACHINE}/errors

exec 1> /dev/null
docker rm -f ${MACHINE_ID}
rm -rf ${MACHINE} ${CODE}
