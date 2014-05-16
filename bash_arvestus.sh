#!/bin/bash
# Autor - Priit Varul A21
# Kuupäev - 16.05.2014
# Skript leiab üles kõik käsurealt etteantud kasutajale kuuluvad failid, kogu failisüsteemist. Failide nimekiri kirjutatakse faili kasutajanimi.txt ja sorteeritakse suuruse järgi. Failis oleks näha nii suurus kui ka failinimi täis pika teena.

if [ $# -ne 1 ]
then 
    echo "parameetrite arv on vale!"
exit 1
fi
    
find / -type f -user $1 -exec ls -l {} \; > /tmp/output.txt
chmod 777 /tmp/output.txt
sort -k 5 < /tmp/output.txt > output2.txt
rm /tmp/output.txt

exit 0
