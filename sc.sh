DTBIMG=dtb.img
DTBSIG="00 00 d0 0d fe ed"
DTBSIGOFF=2
rm -rf ./phone_dts
mkdir -p phone_dts
hexdump -v -e "1/1 \"%02x \"" $DTBIMG >./phone_dts/dtb_hex.txt
unset OFFSETS
unset SIZES
declare -a OFFSETS
declare -a SIZES
BCNT=0
for OFF in `grep -oba "$DTBSIG" ./phone_dts/dtb_hex.txt | awk -F':' '{print $1}'`; \
do \
  let "SIGOFF = OFF/3 + DTBSIGOFF"; \
  let "OFFSETS[BCNT] = SIGOFF"; \
  if [[ $BCNT > 0 ]]; then let "SIZES[BCNT-1] = SIGOFF - OFFSETS[BCNT-1]"; fi; \
  let "BCNT += 1"; \
done
rm ./phone_dts/dtb_hex.txt
ACNT=0
for OFF in "${OFFSETS[@]}"; \
do \
  DTNAME=$(printf "./phone_dts/dt_%02d" $ACNT); \
  if [[ $ACNT == $(($BCNT-1)) ]]; then \
    dd if=$DTBIMG of=$DTNAME.bin ibs=1 skip=$(($OFF)); \
  else \
    dd if=$DTBIMG of=$DTNAME.bin ibs=1 skip=$(($OFF)) count=$((${SIZES[$ACNT]})); \
  fi; \
  ./dtc -I dtb $DTNAME.bin -O dts -o $DTNAME.dts; \
  rm $DTNAME.bin; \
  let "ACNT += 1"; \
done