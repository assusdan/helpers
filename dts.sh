#!/bin/bash

#
# Copyright (c) 2018 - 2019 Danya Suslov
# https://github.com/assusdan
#

# Don't Touch This

DEVICE=$1
DTBIMG=$2
ARG_COUNT="$#"

# ARGS

if [ $ARG_COUNT -lt "2" ]
then
  echo "Not enough arguments were specified, run the script again with proper arguments"
  exit 1
fi

# Start Parsing

DTBSIG="00 00 d0 0d fe ed"
DTBSIGOFF=2
rm -rf ./$DEVICE_$(date +%Y%m%d)
mkdir -p $DEVICE_$(date +%Y%m%d)
hexdump -v -e "1/1 \"%02x \"" $DTBIMG >./$DEVICE_$(date +%Y%m%d)/$DEVICE_hex.txt
unset OFFSETS
unset SIZES
declare -a OFFSETS
declare -a SIZES
BCNT=0
for OFF in `grep -oba "$DTBSIG" ./$DEVICE_$(date +%Y%m%d)/$DEVICE_hex.txt | awk -F':' '{print $1}'`; \
do \
  let "SIGOFF = OFF/3 + DTBSIGOFF"; \
  let "OFFSETS[BCNT] = SIGOFF"; \
  if [[ $BCNT > 0 ]]; then let "SIZES[BCNT-1] = SIGOFF - OFFSETS[BCNT-1]"; fi; \
  let "BCNT += 1"; \
done
rm ./$DEVICE_$(date +%Y%m%d)/$DEVICE_hex.txt
ACNT=0
for OFF in "${OFFSETS[@]}"; \
do \
  DTNAME=$(printf "./$DEVICE_$(date +%Y%m%d)/dt_%02d" $ACNT); \
  if [[ $ACNT == $(($BCNT-1)) ]]; then \
    dd if=$DTBIMG of=$DTNAME.bin ibs=1 skip=$(($OFF)); \
  else \
    dd if=$DTBIMG of=$DTNAME.bin ibs=1 skip=$(($OFF)) count=$((${SIZES[$ACNT]})); \
  fi; \
  ./dtc -I dtb $DTNAME.bin -O dts -o $DTNAME.dts; \
  rm $DTNAME.bin; \
  let "ACNT += 1"; \
done

# Unsetting variables
unset DEVICE
unset DTBIMG
unset ARG_COUNT
