#!/bin/bash

# Pfadeinstellungen:

# PLAIN Text Files
SOURCE="PasswordsAndLogins"
PLAIN_PATH="$HOME/myFiles/Temp-PasswordsAndLogins"
PLAIN_SOURCE=$SOURCE_PATH/$SOURCE_DIR

# CRYPTED Files
CRYPT_PATH="$HOME/myFiles/Privat/PasswordsAndLogins"

echo "Bitte Verschlüsseln = 'v' oder Entschlüsseln = 'e' oder Abbruch = 'a' auswählen.auswählen."
read MODUS
while [ "$MODUS" != "v" ] && [ "$MODUS" != "e" ] && [ "$MODUS" != "a" ];
do
	echo "Bitte v,e oder a eingeben!"
	read MODUS;
done

if [ "$MODUS" = "a" ];
then
	echo "Abbruch!"
	exit
fi


# Verschlüsseln:
if [ "$MODUS" = "v" ];
then
	# Verzeichnis in tar-Archiv umwandeln
	cd $PLAIN_PATH
	tar -czvf $SOURCE.tar.gz $SOURCE
	openssl enc -aes-256-cbc -salt -in $SOURCE.tar.gz -out $SOURCE.tar.gz.enc
	echo rm -r $SOURCE
	rm $SOURCE.tar.gz
	# copy crypted tar.gz.enc nach CRYPT_PATH
	if [ -f $CRYPT_PATH/$SOURCE.tar.gz.enc ];
	then
		# save old tar.gz.enc
		mv $CRYPT_PATH/$SOURCE.tar.gz.enc $CRYPT_PATH/$SOURCE.tar.gz.enc.$(date +%Y%m%d-%T)
	fi
	mv $SOURCE.tar.gz.enc $CRYPT_PATH
fi

if [ "$MODUS" = "e" ];
then
	# entschlüsseln
	openssl enc -aes-256-cbc -d -in $CRYPT_PATH/$SOURCE.tar.gz.enc -out $PLAIN_PATH/$SOURCE.tar.gz
	cd $PLAIN_PATH
	tar -xzf $SOURCE.tar.gz
	rm $SOURCE.tar.gz
fi