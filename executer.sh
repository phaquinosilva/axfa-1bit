#! /bin/bash

echo
echo "Simulation executer"
for i in $(find . -name "*meas*.cir")
do
echo "Simulating: $i"
hspice $i -o OUTPUT_DATA/${i%.*}.csv
done

echo "Done."
echo
