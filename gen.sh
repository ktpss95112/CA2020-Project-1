#!/usr/bin/env bash

TARGET=GodKaienLinAndHisWorshippers_project1
TMPFOLDER=/tmp/$RANDOM/$TARGET

if [[ -f ${TARGET}.zip ]]; then
    rm -f ${TARGET}.zip
fi

mkdir -p $TMPFOLDER/codes

cp codes/*.v $TMPFOLDER/codes
cp report.pdf $TMPFOLDER/${TARGET}.pdf

rm $TMPFOLDER/code/Instruction_Memory.v
rm $TMPFOLDER/code/Data_Memory.v
rm $TMPFOLDER/code/PC.v
rm $TMPFOLDER/code/Registers.v

zip -r ${TARGET}.zip $TMPFOLDER

rm -rf $TMPFOLDER
