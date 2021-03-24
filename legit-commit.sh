#!/bin/dash

#error handling if .legit is uninitailized
if test ! -d ./.legit/
then
	echo "legit-commit: error: no .legit directory containing legit repository exists"
	exit 1
fi

currB=`cat ./.legit/commits/currBranch`

if test $# -eq 2 #if in the form of "-m message"
then
	echo $1|egrep "^-m$" >/dev/null
	if test $? -ne 0 #if arg1 isn't "-m"
	then
		echo "usage: legit-commit [-a] -m commit-message"
		exit 1
	fi
	
	echo $2|egrep "^-.+$" >/dev/null
	if test $? -eq 0 #if arg2 is in the form of "-something"
	then
		echo "usage: legit-commit [-a] -m commit-message"
		exit 1
	fi

	message="$2"
elif test $# -eq 3 #if in the form of "-a -m message"
then
	echo $1|egrep "^-a$" >/dev/null
	if test $? -ne 0 #if arg1 isn't "-a"
	then
		echo "usage: legit-commit [-a] -m commit-message"
		exit 1
	fi

	echo $2|egrep "^-m$" >/dev/null
	if test $? -ne 0 #if arg2 isn't "-m"
	then
		echo "usage: legit-commit [-a] -m commit-message"
		exit 1
	fi

	echo $3|egrep "^-.+$" >/dev/null
	if test $? -eq 0 #if arg3 is in the form of "-something"
	then
		echo "usage: legit-commit [-a] -m commit-message"
		exit 1
	fi
	
	find ./.legit/index/files/ -type f|
	while read each
	do
		toAdd=`echo $each|rev|cut -d'/' -f1|rev`
		legit-add $toAdd
	done
	message="$3"
else
	echo "usage: legit-commit [-a] -m commit-message"
	exit 1
fi

#check if there's anything to commit:
#1.check if all file states in index are 0, if they are:
#2.check if all files in repo are in in index/files, if they are:
#there is nothing to commit

decision=0 #0 means nothing to commit
curr=`cat ./.legit/commits/branches/$currB/currCommit`
ls ./.legit/commits/objects/"commit$curr"|egrep "." >/dev/null
if test $? -eq 0
then
	for each in ./.legit/commits/objects/"commit$curr"/*
#find ./.legit/commits/objects/"commit$curr"/ -type f|
#while read each
	do
		justName=`echo $each|rev|cut -d'/' -f1|rev`
		toFind=./.legit/index/files/"$justName"
		if test ! -f $toFind #if repo has file(s) that index doesn't have
		then 
			decision=1
		fi
	done
fi

ls ./.legit/index/state|egrep "." >/dev/null
if test $? -eq 0
then
	for eachState in ./.legit/index/state/*

#find ./.legit/index/state/ -type f|
#while read eachState  #see if all file states are 0
	do
		res=`cat $eachState`
		if test $res -eq 1
		then
			decision=1
		fi
	done
fi

if test $decision -eq 0
then
	echo "nothing to commit"
	exit 0
fi


#update current commit index to both commits/rep and branches/$currB/currCommit
old=`cat ./.legit/commits/rep`
new=$((old+1))
echo $new >./.legit/commits/rep
echo $new >./.legit/commits/branches/$currB/currCommit
echo $new >./tmp
cat ./.legit/commits/branches/$currB/itsCommits >> ./tmp
cp ./tmp ./.legit/commits/branches/$currB/itsCommits 
rm ./tmp
#generate differences between current commit and all ancestor commits

for branch in "./.legit/commits/branches"/* # $branch is each existing branch
do
	#skip current branch when finding all branches
	echo $branch|egrep "^$currB$" >/dev/null
	if test $? -eq 0
	then
		continue
	fi

	#create a directory to store commit differences between current-branch and $branch
	mkdir ./.legit/commits/branches/$currB/commitDiff/$branch

	tac "./.legit/commits/branches/$branch/itsCommits"|
	while read commit 
	do
		cat "./.legit/commits/branches/$currB/itsCommits"|egrep "$commit" >/dev/null
		if test $? -eq 0 #----$commit is now the ancestor commit of $currB and $branch
		then
			for eachfile in "./.legit/commits/objects/commit$commit/"
			do #----compare files that exist in both commits by "diff"
				fileN=`echo $eachfile|rev|cut -d'/' -f1|rev`
				currComFile="./.legit/commits/objects/commit$new/$fileN"
				if test -f $currComFile #----if currComFile exists
				then
					#store diff between files
					cmpBranch="./.legit/commits/branches/$currB/commitDiff/$branch"
					diff "$eachfile" "$currComFile" >"$cmpBranch/$fileN"
				fi
			done
		fi
	done
done
			
			










#create message file with corresponding commit as filename
echo "$message" > ./.legit/commits/head/"commit$new"

#create a new repo "commit$new"
#to store all commited files from index
mkdir ./.legit/commits/objects/"commit$new"

#grab all files from index/files
#and copy them to commits/objects/commit$new
find ./.legit/index/files/ -type f|
while read file
do
	cp "$file" ./.legit/commits/objects/"commit$new"
done

#update status in index/state
find ./.legit/index/state/ -type f|
while read every
do
	echo 0 >"$every"
done

#print message to user
echo "Committed as commit $new"














	
