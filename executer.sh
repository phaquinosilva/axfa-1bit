#! /bin/bash
echo
echo "=====Simulacao====="
for i in $(find . -name "*meas*.cir")
do
echo "Simulando: $i"
hspice $i
done

echo "=====Fim da Simulacao====="
echo
