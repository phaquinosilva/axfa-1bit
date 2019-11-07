#! /bin/bash

echo "Simulation executer for near-threshold results"
for i in $(find . -name "*meas*.cir")
do
  echo "Simulating: $i"
  INTERVAL=1
  VOLT=7
  for j in {1..10}; do
    if ["$VOLT" -lt "2"];
    then
      break                                                 # sai do loop caso a tensão seja menor que 0.2V
    fi
    NEXT_VOLT=$((VOLT - 1))                                 # define tensão para a nova simulação
    sed 's/vdd = 0.'"$VOLT"'V/vdd = 0.'"$NEXT_VOLT"'V'      # substitui a tensão antiga pela nova
    VOLT=$NEXT_VOLT                                          # define tensão atual como a nova tensão
    hspice ${i%.*}.cir                                      # roda simulação
    if [grep -q failed ${i%.*}.csv != 0];
    then
      NEXT_INTERVAL=$((INTERVAL+1))                         # define o novo intervalo
      sed 's/m = '"$INTERVAL"'n/m = '"$NEXT_INTERVAL"'n'    # substitui o período antigo pelo novo
      INTERVAL=$NEXT_INTERVAL;                               # define o intervalo atual como o novo intervalo
    else
      mv ${i%.*.*}.mt0.csv ${i%.*.*}"0."${VOLT}.csv               # renomeia o arquivo para a tensão correta
      echo "End of simulation in 0.${VOLT}V"                # simulado em qual tensão
      break                                                 # sai do loop do arquivo e simula o próximo arquivo
    fi
  done
done


echo "Moving results to OUTPUT_DATA"
mkdir OUTPUT_DATA/NT
for i in $(find . -name "*.csv");
do
  mv $i OUTPUT_DATA/NT
done


# echo "Adding results to AC Simulations respository in GitLab"
# git add OUTPUT_DATA/NT
# git commit -m "near-threshold results"
# git push

echo "Simulations done."
