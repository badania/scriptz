#!/bin/bash

##### SERVER CONFIGURATION ####
#"Voulez-vous utiliser cet ordnateur comme serveur?
#Le serveur permettra de publier des contenus sur
#Internet directement à partir de cette machine. Il
#utilise Dokuwiki comme page d'accueil, fournit un
#blog propulsé par Chyrp, le système de chat et
#d'édition collaborative de documents EtherPad, une
#gallerie photo PhotoShow et le service de transfert
#de fichiers anonyme et décentralisé Filetea. Il
#permet également un accès à distance sécurisé à vos
#fichiers sur cet ordinateur via le service SSH."

##oui/non

#"Choisissez les composants à installer:
# * Page d'accueil Dokuwiki (obligatoire)
# * Blog Chyrp
# * Gallerie Photoshow
# * Bloc-Notes Etherpad Lite
# * Transfert de fichiers par Filetea
# * Activer le serveur SSH"
 
#install serveur Apache (Désactivé)
#install des applis web dans /usr/share/
#copie vers /var/www
#Setup des mots de passe, sed dans les fichiers de conf
#Setup du nom de domaine
#activation du serveur
#création lien symbolique vers /var/www/ dans ~
#proposer d'ajouter l'utilisateur au group www-data
#Lien vers les interfaces d'admin

#Désinstalleur chyrp: proposer de supprimer /var/www/chyrp/
#Désinstalleur dokuwiki: proposer de supprimer /var/www/dokuwiki/
#Désinstalleur Photoshow: proposer de supprimer /var/www/photoshow/
