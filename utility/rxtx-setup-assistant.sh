#!/bin/bash
#Setup Assistant v0.1
#TODO: Localize in english/more. See http://www.tldp.org/LDP/abs/html/localization.html



#Define functions
##User account configuration
function SetupUsers() {
zenity --question --width=350 --height=100 --title "Configuration des comptes utilisateur" --text "Si vous souhaitez pouvoir ouvrir une session sans mot de passe, accorder des privilèges d'administration à votre utilisateur, ou ajouter des comptes pour d'autres utilisateurs, vous pouvez lancer l'utilitaire de gestion des comptes utilisateur. Voulez-vous le faire maintenant?"
if [ $? = 0 ]
	then gnome-control-center user-accounts
fi
}

##detect if we are in sudoers, if no, propose to add user to sudoers
function AddToSudo() {
groups | grep sudo || zenity --question --width=350 --height=100 --title "Groupe sudo" --text "Voulez-vous ajouter votre utilisateur au groupe <tt>sudo</tt> afin de pouvoir utiliser la commande <tt>sudo</tt> (exécuter en tant qu'administrateur) dans le terminal?"
if [ $? = 0 ]
	then pkexec addgroup $USER sudo
fi
}

##Connect to Network
function ConnectToNetwork() {
zenity --question --width=350 --height=100 --title "Connection au réseau" --text "Pour continuer l\'installation, il est préférable de disposer d'une connection à Internet. Voulez-vous paramétrer une connection réseau maintenant?"
if [ $? = 0 ]
	then gnome-control-center network
fi
}

##Setup date/time
function SetupDateTime(){
zenity --question --width=350 --height=100 --title "Réglage de l'heure" --text "Voulez-vous modifier les paramètres pour la date et l'heure?"
if [ $? = 0 ]
	then gnome-control-center timeadmin
fi
}

##Setup power preferences
function SetupPowerPrefs() {
zenity --question --width=350 --height=100 --title "Paramètres d'alimentation" --text "Voulez-vous modifier les paramètres de gestion de l'alimentation et de mise en veille?"
if [ $? = 0 ]
	then gnome-control-center power
fi
}

##Setup display preferences
function SetupScreenPrefs() {
zenity --question --width=350 --height=100 --title "Paramètres de l'écran" --text "Voulez-vous modifier les paramètres de luminosité et d'alimentation de l'écran?"
if [ $? = 0 ]
	then gnome-control-center screen
fi
}

##Setup autostarted apps
function SetupAutostart() {
zenity --question --width=350 --height=100 --title "Applications au démarrage" --text "Voulez-vous modifier les applications démarrées automatiquement?"
if [ $? = 0 ]
	then lxsession-edit
fi
}

#propose to setup an xmpp account #TODO: proper tutorial
function RegisterXmpp() {
zenity --question --width=350 --height=100 --title "Messagerie XMPP/Jabber" --text "XMPP est un protocole de messagerie instantanée universel, libre et ouvert. Il est recommandé d'utiliser un compte de messagerie XMPP pour discuter en ligne. Si vous ne possédez pas de compte XMPP, vous pouvez en créer un en quelques secondes, sur un fournisseur de votre choix. Référez-vous à <a href=http://somexmpplink.org>SomeXmppLink</a> pour comparer différents services. Voulez-vous créer un compte de messagerie XMPP sur Jabber.org maintenant?"
if [ $? = 0 ]
	then xdg-open "https://register.jabber.org/"
fi
}

#Setup Firefox Addons
function SetupFFAddons() {
zenity --question --width=350 --height=100 --title "Modules complémentaires de Iceweasel" --text "Le navigateur web Iceweasel (basé sur Mozilla Firefox) dispose de nombreuses extensions permettant d'ajouter des fonctionnalités. Certaines extensions sont activées par défaut, cependant, si vous souhaitez activer d'autres extensions préinstallées, vous pouvez le faire maintenant. Souhaitez vous choisir les extensions à activer?"
if [ $? = 0 ]
	then firefox "about:addons"
fi
}


#Run functions in this order
SetupUsers
AddToSudo
ConnectToNetwork
CheckIfConnected #TODO
SetupDateTime
SetupPowerPrefs
SetupScreenPrefs
SetupAutostart
RegisterXmpp
SetupFFAddons



#detect available RAM, to suggest lightweight applications if necessary.
#MEMTOTAL=`cat /proc/meminfo | head -n 1 | awk '{print $2}'`

##SYSTEM WIDE SETTINGS
#detect if /usr/share/rxtx/systemconfigdone exists, if it does, skip system wide settings
#if [ !-e /usr/share/rxtx/systemconfigdone ]
#	then dosystemconfig
#fi

#detect software rendering, if yes, propose compiz, if no, propose drivers

#propose using AWN






#inform user about enabling pgl, cups, samba and avahi, ssh, saned, bluetooth, preload, 
#services-admin

#if enabled, warn about ssh security, warn about pgl potential blocking

#propose to install recommended applications

##### USER SPECIFIC SETTINGS #########


#propose to choose default applications, if yes
#gnome-control-center info

#let user choose between synapse and cardapio
#if cardapio chosen, sed -i 's/synapse.desktop/cardapio.desktop/g' ~/.config/tint2/tint2rc

#propose tint2 config

#propose to tweak appearance, if yes
lxappearance
 * 



#gnome-control-center printers
#gnome-screensaver-preferences

#gnome-power-preferences

#gnome-display-properties

#gnome-keyboard-properties

#time-admin



#users-admin

#dridetect

#update-manager -c

#mail-notification -p &

#propose installing flash player


#configure pidgin accounts
#pidgin &

#configure mail notifications
#mail-notification -p &

# configure thunderbird accounts
#thunderbird &

#Vous pourrez modifier ces réglages plus tard en accedant au Centre de Contrôle depuis le menu Système.

#if drivers have been installed, propose reboot




