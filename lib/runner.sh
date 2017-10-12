#!/bin/bash

# Input: uuid runner timeout memory cpus max_output
# Available runners: ruby python python3 nodejs

exec &> /dev/null

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
STORE="${ROOT}/store"
MACHINE="${STORE}/${1}"
CODE="${STORE}/code/${1}"

mkdir ${MACHINE} && cp ${STORE}/default/* ${MACHINE}
cp ${CODE} ${MACHINE}/code && rm ${CODE}
chmod 744 -R ${MACHINE}

MACHINE_ID=$(docker run -d --read-only --memory=${4} --cpus=${5} -v ${MACHINE}:/code compiler_machine /code/run.sh ${2} code ${6:-2K})

# Because executor user doesn't have write access, so the only file that will be created is `time`
# This file is created at the very end of our script, so we use it to know when we're done
# It's also possible to do it with `docker wait` and timeout, but it was about 100ms slower
if ! inotifywait -t ${3} -qq -e create ${MACHINE}; then
    echo -1 > ${MACHINE}/time
fi

docker rm -f ${MACHINE_ID}
