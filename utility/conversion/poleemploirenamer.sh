#!/bin/bash
#Description: assigne un nom de fichier correct aux courriers téléchargés depuis le site de pôle emploi.
#Source: https://github.com/nodiscc/scriptz
#License: MIT (http://opensource.org/licenses/MIT)


for i in 20*.pdf #Assume que les noms de fichiers ont ce format, ce qui n'est pas toujours le cas
do

if [[ `pdfgrep "RELEVE DE SITUATION" "$i" 2>/dev/null` ]]
then #Le document est un relevé de situation
	SUBJECT="Relevé de situation"
else #Récupérer le titre depuis la ligne "Objet:"
	SUBJECT=`pdfgrep Objet "$i" 2>/dev/null | cut -f 1-2 -d " " --complement  | sed -e "s/'/_/g"`
fi

DOCDATE=`pdfgrep ", le " "$i" 2>/dev/null | awk '{print ( $(NF) " " $(NF-1) " " $(NF-2) )}'` #TODO convert 3 last fields to standard date
NEWNAME="Pole Emploi ${SUBJECT} ${DOCDATE}.pdf"

mv $i "$NEWNAME"
done
