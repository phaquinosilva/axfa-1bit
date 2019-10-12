#! /bin/bash
echo
echo "Simulation executer"
for i in $(find . -name "*meas*.cir")
do
echo "Simulating: $i"
hspice $i
done

echo "Done."
echo
