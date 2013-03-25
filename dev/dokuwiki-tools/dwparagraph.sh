#!/bin/bash
#Create a dokuwiki paragraph
#Formatting:== package name==
#**shortdescription** - longdescription
#package-lists
#screenshots
#external links
#TODO: fix bad indentation an newlines in PACKAGE_LONGDESCR
#TODO: allow overriding PACKAGE_LONGDESCR with a key like #Override: true, and get long description from lines starting with "# "
#Copyright: Rxtx Project <nodiscc@gmail.com>
#License: GPL (https://www.gnu.org/licenses/gpl)


##PACKLIST Rules
#The script takes live-build (http://live.debian.net) package lists as arguments.
#There are several special fields allowed in package lists.
#Name, Replace, Append, Resource, Details
#TODO: Parse package lists to be usable in tasksel

PACKLIST="$1"
PACKREALNAME=`cat "$PACKLIST" | grep -e "^#Name" | cut -f 1 -d " " --complement`
MAINPACKAGE=`cat "$PACKLIST"  | egrep -v "^#" | head -n 1`
SHOWPKG=`apt-cache show $MAINPACKAGE`
PACKAGE_DESCR=`echo "$SHOWPKG" | egrep "^Description" | egrep -v "Description-md5" | uniq | cut -d " " -f2-`;
PACKAGE_LONGDESCR=` echo "$SHOWPKG" | egrep "^ " | egrep -v "::" | sed -e 's/ \./\n/g' | sed 's/  - /  * /g'`
HOMEPAGE=`echo "$SHOWPKG" | egrep "^Homepage" | uniq | cut -d " " -f2-`;
RESOURCES=`cat "$PACKLIST" | grep "^#Resource" | cut -f 1 -d " " --complement`
PACKAGES_NAMES=`cat $PACKLIST | egrep -v "^#" | tr "\n" " "`
THUMBNAILSIZE=150
NAMESPACE=":rxtx:"
SCREENSHOTDIR="$HOME/Téléchargements/screens/rxtx"


#Create Main Package name
echo "===== $PACKREALNAME ====="

#Create Package description
echo -n "**$PACKAGE_DESCR** - "
echo "$PACKAGE_LONGDESCR"
echo

#Create package list
echo "//Paquets: $PACKAGES_NAMES//"
echo

#TODO: create apt:// links


#create screenshots
for IMAGE in `find $SCREENSHOTDIR/uploaded/ $SCREENSHOTDIR/accepted/ -name "*$MAINPACKAGE*"`
do
        SCREENSHOT=$(basename "$IMAGE")
        echo "{{${NAMESPACE}${SCREENSHOT}?direct&$THUMBNAILSIZE|}}"
done
echo



#Create Homepage Link
if [ "$HOMEPAGE" != "" ]
	then echo "  * [[$HOMEPAGE|Site Officiel]]"
fi


#Create Links
for RESURL in $RESOURCES
	do
	RESOURCETITLE=`wget "$RESURL" -q -O - | awk -vRS="</title>" '/<title>/{gsub(/.*<title>|\n+/,"");print;exit}'`
	echo "  * [[$RESURL|$RESOURCETITLE]]"
done

