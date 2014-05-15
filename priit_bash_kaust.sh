#!/bin/bash
# Autor - Priit Varul A21
# Kuupäev - 13.05.2014
# Skript mis jagab etteantud grupile uue kausta.

LC_ALL=C

# Kontrollib, kas kasutaja on juurkasutaja


if [ $UID -ne 0 ]
    then 
    echo "Käivita skript juurkasutajana!"
    exit 1

fi

# Kontrollime parameetreid.

KAUST=$1
GRUPP=$2

if [ $# -eq 3 ]
then
    SHARE=$3
    
elif [ $# -eq 2 ]
then
    SHARE=$(basename $KAUST)

else 
    echo "Parameetrite arv on vale, käivita programm järgnevalt:"
    echo "$0 KAUST GRUPP [SHARE]"
    exit 2
fi
    
echo "Jagan kausta $KAUST grupile $GRUPP share'ina $SHARE"

# Paigaldame vajaduse korral Samba.

   type smbd || apt-get update >/dev/null && apt-get install samba smbclient


# Lisame vajaduse korral grupi

if [ $(getent group $GRUPP ) ]
    then
        echo "Gruppi ei pea looma, see on juba olemas."
    else 
        echo "Loon grupi $GRUPP"
        groupadd $GRUPP
fi

# Loome vajaduse korral kausta

    
    find $KAUST || echo "Teen kausta $KAUST" 
    mkdir -p $KAUST
    
# Määrame kaustale õigused 

    echo "määran kaustale õigused"
    chgrp $GRUPP $KAUST
    chmod g+w $KAUST
    
# Teen smb.conf'ist varukoopia

    cp /etc/samba/smb.conf /etc/samba/smb.conf.varu
    
# Kirjutame sheeri smb.conf'i

    cat >> /etc/samba/smb.conf << end
    
[$SHARE]
read only = no
path = $KAUST
valid users = @$GRUPP
force group = $GRUPP
create mask = 770
directory mask = 770
end

# Kontrollime smb.conf'i testparm'iga

if [ $(testparm -s &>/dev/null; echo $?) -eq 1 ];
    then
        echo "smb.conf'is esines viga, taastan algse backupi"
        rm /etc/samba/smb.conf
        mv /etc/samba/smb.conf.varu /etc/samba/smb.conf
        exit 1
fi

echo "smb'ga kõik korras"

# Teeme failiserveri teenusele reload'i
    
    echo "teeme smb'le reload"
    service smbd reload
