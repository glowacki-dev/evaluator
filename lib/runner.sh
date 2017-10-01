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
chmod 777 -R ${MACHINE}

MACHINE_ID=$(docker run -d --memory=40m --cpus=0.25 -it -v ${MACHINE}:/code compiler_machine /code/run.sh ${2} code)

if [ $(timeout 5s docker wait ${MACHINE_ID}) ]; then
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
