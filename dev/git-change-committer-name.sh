#!/bin/sh
#from https://help.github.com/articles/changing-author-info

git filter-branch --env-filter '

an="$GIT_AUTHOR_NAME"
am="$GIT_AUTHOR_EMAIL"
cn="$GIT_COMMITTER_NAME"
cm="$GIT_COMMITTER_EMAIL"

if [ "$GIT_COMMITTER_EMAIL" = "nodiscc@gmail.com" ]
then
    cn="badsuperblock"
    cm="badsuperblock@telecom.dmz.se"
fi
if [ "$GIT_AUTHOR_EMAIL" = "nodiscc@gmail.com" ]
then
    an="badsuperblock"
    am="badsuperblock@telecom.dmz.se"
fi

export GIT_AUTHOR_NAME="$an"
export GIT_AUTHOR_EMAIL="$am"
export GIT_COMMITTER_NAME="$cn"
export GIT_COMMITTER_EMAIL="$cm"
'

