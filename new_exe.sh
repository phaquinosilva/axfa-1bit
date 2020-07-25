#! /bin/bash
PATH="$PATH":/home/user/bin

echo "Simulation executer for near-threshold results"
touch sim_times
for i in $(find . -name "buffer*_*.cir")
do
  y=${i%.*}
  y=${y##*/}
  echo "Simulating: $y"
  INTERVAL=1
  VOLT=8
  for j in {1..10}; do
    if [ $VOLT -lt 2 ]; then
        echo
        break                                                 # sai do loop caso a tensão seja menor que 0.2V
    fi
    perl -i.bak -p -e "s/\bvdd = 0."$VOLT"V\b/vdd = 0."$((VOLT - 1))"V/" $i
    VOLT=$((VOLT - 1))                                          # define tensão atual como a nova tensão
    hspice $i                                               # roda simulação
    if grep -q failed "${y##*/}.mt0.csv"; then
      perl -i.bak -p -e "s/\bm = "$INTERVAL"n\b/m = "$((INTERVAL + 1))"n/" $i
      INTERVAL=$((INTERVAL + 1));                               # define o intervalo atual como o novo intervalo
    else
      mv $y.mt0.csv $y"_0."$VOLT"".csv               # renomeia o arquivo para a tensão correta
      echo "End of simulation in 0.${VOLT}V"                # simulado em qual tensão
      echo "Circuit: $i" >> sim_times
      echo "→  voltage: 0."$VOLT"" >> sim_times
      echo "→  interval: "$INTERVAL"" >> sim_times
      echo "   " grep tran $i >> sim_times
      echo >> sim_times
      continue                                                 # sai do loop do arquivo e simula o próximo arquivo
    fi
  done
done

echo "Moving results to OUTPUT_DATA"
mkdir OUTPUT_DATA/buffer
for i in $(find . -name "buffer*.csv");
do
  mv $i OUTPUT_DATA/buffer
done

# echo "Adding results to AC Simulations respository in GitLab"
# git add OUTPUT_DATA/NT
# git commit -m "near-threshold results"
# git push

echo "Simulations done."

