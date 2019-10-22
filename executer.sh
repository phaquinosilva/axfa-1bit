#! /bin/bash

echo
echo "Simulation executer"

for i in $(find . -name "*meas*.cir")
do
  echo "Simulating: $i"
  hspice $i #! -o OUTPUT_DATA/${i%.*}.csv
done

#! echo "Moving results to OUTPUT_DATA"
#! for i in $(find . -name "*.csv")
#! do
#!   mv $i OUTPUT_DATA
#! done
#! 
echo "Done."
echo
