#!/bin/bash
# Processes a PDF file. Merges pairs of pages into single pages.

if ! command -v zenity1 &> /dev/null
then
    echo "'zenity' could not be found. Please check that zenity is installed."
    exit 1
fi

if ! command -v pdfjam &> /dev/null
then
    echo "'pdfjam' could not be found. Please check that pdfjam is installed."
    exit 1
fi

`zenity --info --title="PDF Merging Page Pairs" --text="Processes a PDF file.\n Merges pairs of pages into single pages.\n Each pair into one page."`

`zenity --info --text="First select the source file"`
IN_FILE=`zenity --file-selection --title="Select the source file"`
if [ $? == 0 ]; then
    echo "\"$IN_FILE\" selected."
else
    exit
fi

`zenity --info --text="Now select the output file"`
OUT_FILE=`zenity --file-selection --save --title="Select the output file"`
if [ $? == 0 ]; then
    echo "\"$OUT_FILE\" selected."
else
    exit
fi

WIDTH=`zenity --entry --title="Width" --text="Enter the width in mm"`
if [ $? == 0 ]; then
    echo "\"$WIDTH\" selected."
else
    exit
fi

HEIGHT=`zenity --entry --title="Height" --text="Enter the height in mm"`
if [ $? == 0 ]; then
    echo "\"$HEIGHT\" selected."
else
    exit
fi

`zenity --question --text="Add a separating frame??"`
if [ $? == 0 ]; then
    FRAME="--frame true"
else
    FRAME=""
fi

`pdfjam --suffix nup --nup '2x1' --papersize "{${HEIGHT}mm,${WIDTH}mm}" ${FRAME} --landscape "$IN_FILE" --outfile "$OUT_FILE"`
if [ $? == 0 ]; then
    `zenity --info --text="Done. Check output file."`
else
    `zenity --info --text="Error"`
    exit 1
fi

#pdfjam --suffix nup --nup '2x1'  --delta '{1mm 0mm}' --landscape 1.pdf
