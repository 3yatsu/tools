#!/bin/bash
N=${1}
TARGET=${2}

ENTRIES=`cat ${N}`
for i in ${ENTRIES}
do
  DIRNAME=.`dirname ${i}`
  FILENAME=`basename ${i}`
  svn export ${TARGET}/${i}
  mkdir -pv ${DIRNAME}
  mv -v ${FILENAME} ${DIRNAME}
done