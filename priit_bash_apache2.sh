#!/bin/bash
# Autor - Priit Varul A21
# Kuupäev - 14.05.2014
# Skript loob uue veebikodu kasutaja sisestusel

LC_ALL=C

#Kontrollitakse, kas kasutajal on juurkasutaja õigused.

if [ $UID -ne 0 ]

then

echo "Käivita skript juurkasutaja õigustega!"

exit 1

fi

# Parameetrite kontroll

ADDRESS=$1

if [ $# -ne 1 ];

then

	echo "käivita skript järgmiselt: ./priit_bash_apache2 www.minuveebisait.ee"

	exit 1

fi

# Paigaldame vajaduse korral apache 2 serveri (Kui see puudub)

type apache2 || apt-get update >/dev/null && apt-get install apache2

# Loome nimelahenduse /etc/hosts faili 

echo "127.0.0.1 $ADDRESS" >> /etc/hosts

# Teeme nimelise kausta mille kasutaja sisestas.

mkdir -p /var/www/$ADDRESS

# Kirjutame loodud veebilehe sites-available sisse.
cp /etc/apache2/sites-available/default /etc/apache2/sites-available/$ADDRESS
sed -i 's/ServerAdmin webmaster@localhost/ServerAdmin webmaster@'$ADDRESS'\n\tServerName '$ADDRESS'/' /etc/apache2/sites-available/$ADDRESS
sed -i 's@DocumentRoot /var/www@DocumentRoot /var/www/'$ADDRESS'@' /etc/apache2/sites-available/$ADDRESS

# Kopeerime default index.html kasutaja loodud kausta.

cp /var/www/index.html /var/www/$ADDRESS/

# Lubame loodud veebisaidi.

	a2ensite $ADDRESS
	service apache2 reload

exit 0  
