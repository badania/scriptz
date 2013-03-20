#!/bin/bash
#Retrieve a local copy of your accounts data from several web services.
# * Github
# * Reddit
# * Deviantart
# * Vimeo
# * Twitter
# * Identica/Statusnet
# * All sites on stackoverflow
# * Gmail
# * IMAP Mail
# * Last.fm
# * Grooveshark
#
#TODO:
# * COuld use a good rewrite!
#   * separate modules in .backupmodule files
#   * list available modules with --list-modules
#   * put the variables (usernames;passwords) in a .config file
#	* ....
# * Redirect outputs to text files
# * clear variables on exit
# * Intercative mode: ask for services to backup, prompt for username/passwords
#
#Dependencies: googlecl, curl, python-jsonpipe, xmlstarlet
#and of course grep, awk, cut, sed, coreutils...

GHUSER=nodiscc
DAUSER=nodiscc
GOOGLEUSER=nodiscc
VIMEO_USER=nodiscc
LASTFM_USER=nodiscc
LASTFM_APIKEY=9b6009eca365ded3a03c2b9673d54eb9
IDENTICA_USER=nodiscc
REDDIT_USER=nodiscc
REDDIT_PASSWD=
GROOVESHARK_USER=nodiscc

### Github
#list watched repos
curl -s https://api.github.com/users/$GHUSER/watched | jsonpipe  #...
#list own repos
curl -s https://api.github.com/users/$GHUSER/repos | jsonpipe
#list and download tarballs
curl -i -s https://api.github.com/repos/$FULL_NAME/tarball/master |grep Location | cut -b 1-10 --complement


#Last.fm
#Reference http://www.lastfm.fr/api/
#Get the user's 200 most recently scrobbled tracks
#bug: outputs in us-ascii encoding, please convert to utf-8
curl "http://ws.audioscrobbler.com/2.0/user/?method=user.getRecentTracks&user=$LASTFM_USER&limit=200&format=json&api_key=$LASTFM_APIKEY" | \
jsonpipe |egrep "artist/\#text|/name" | cut -f 1 --complement | paste - - | \
sed 's/\"\t\"/\ \-\ /g' | sed 's/\"//g'

#Grooveshark
##Get user playlists
##bug: cleanup output
curl -d "username=$GROOVESHARK_USER" "http://gsplaylists.com/playlists"|html2text

### Deviantart
#list and download favorites
#http://backend.deviantart.com/rss.xml?q=favby%3A$DAUSER

##Vimeo
###Likes
#http://vimeo.com/api/v2/$VIMEO_USER/likes.json


#Reddit
##Login
curl -d user="$REDDIT_USER" -d passwd="$REDDIT_PASSWD" -c reddit_cookie.txt https://pay.reddit.com/api/login

if [[ ! `grep "reddit_session" reddit_cookie.txt` ]]
	then echo "Reddit login failed"
	exit 0
fi

REDDIT_SESSION=`grep reddit_session reddit_cookie.txt |awk '{print $7}'`

##Get authentication vars (old code. looks like it's not necessary)
#REDDIT_MODHASH=`cat cookie.json|jsonpipe|grep modhash | awk '{print $2}'`
#REDDIT_COOKIE=`cat cookie.json|jsonpipe|grep cookie | awk '{print $2}'`

##All my subscribed reddits
MYSUBREDDITS=`curl -s -b reddit_session="$REDDIT_SESSION" 'https://pay.reddit.com/reddits/mine/.json?limit=2000' | jsonpipe | egrep "data/children/.*/data/url" | awk '{print $2}'`
MYSUBREDDITS_FORMATTED=`\
for SUBREDDIT in $MYSUBREDDITS;
do
	echo "URL: https://pay.reddit.com${SUBREDDIT}.rss" | sed 's/"//g'
done`

echo $MYSUBREDDITS_FORMATTED
###Subscribed reddits sidebars

##My saved threads
####Convert saved threads to HTML/PDF?


##Stackoverflow
##My favorite questions
##Convert favoritte questions to HTML/PDF?

#Twitter
##See twidge http://packages.debian.org/wheezy/twidge 
##Buggy. On the first run you should be asked to authenticate with oauth
#Save my tweets
twidge lsarchive -a
#Save my followers
twidge lsfollowers
#Save followed accounts
twidge lsfollowing

#Gmail
##COntacts
## Buggy. Doesnt display autohrization dialog.
google contacts list \
--fields=name,title,organization,email,phone,im,website,other,notes \
--delimiter=" --- " --title="" | sed 's/ --- None//g' |sort \
> Contacts-$GOOGLEUSER-`date +%d%m%y` 

#IMAP Mail
##Try with offlineimap

#Identica
##found at http://www.splitbrain.org/blog/2010-11/30-backup_your_identi.ca_statuses_with_xmlstarlet_and_8_lines_of_bash
##Alternatively: do it using twidge http://packages.debian.org/wheezy/twidge
##Save my posts
num=$(xmlstarlet sel --net -t -m "//user" -v "statuses_count" "http://identi.ca/api/users/show/$IDENTICA_USER.xml")
pages=$((num / 200))

for page in $(seq 1 $((pages + 1)))
	do
	xmlstarlet sel --net -t -m "//status" -v "created_at" -o " " -v "text" -n "http://identi.ca/api/statuses/user_timeline/$IDENTICA_USER.xml?count=200&page=${page}"
	sleep 5
done

##Save my subscriptions
##...






#----------------------------------------------------------------
#May be helpful
#Tanks to https://bbs.archlinux.org/viewtopic.php?id=131526
#!/bin/bash
#case "$1" in
#  get)
##Uncomment below if you want to.
##curl -s http://www.reddit.com/r/$2.json | jshon -e data -e children -a -e data -e url -u | grep '.\(jpe\|jp\|pn\)g$'
##curl -s http://www.reddit.com/r/$2.json | jshon -e data -e children -a -e data -e url -u | grep '.\(htm\|html\|\)g$'
##curl -s http://www.reddit.com/r/$2.json | jshon -e data -e children -a -e data -e url -u | grep '\(youtube\|html\|\)g$'
##curl -s http://www.reddit.com/r/$2.json | jshon -e data -e children -a -e data -e url -u 
##curl -s http://www.reddit.com/r/$2.json | jshon -e data -e children -a -e data -e title -u 
#curl -s http://www.reddit.com/r/$2.json | jshon -e data -e children -a -e data -e url -u 	 
#        exit  
#        ;;
#  title)
#curl -s http://www.reddit.com/r/$2.json | jshon -e data -e children -a -e data -e title  -u      
#;;

#  help)
#echo "run ./reddit get subredditname"
#echo "run ./reddit title subdredditname "
#;;

# user)
#curl -s http://www.reddit.com/user/$2.json | jshon -e data -e children -a -e data -e body -u         
#;;

# login)
#echo "Reddit Username?"
#read user
#echo "Reddit Password?"
#read passwd
#curl -s -d "api_type=json&passwd=$passwd&user=$user" http://www.reddit.com/api/login/$user >> cookie.json
##curl -s https://ssl.reddit.com/prefs/friends.json | jshon -e data -e children -a -e data -e name -u  
#;;
#esac
