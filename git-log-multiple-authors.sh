AUTHORS=""
while getopts "a:" opt; do
	case $opt in
		a)
			AUTHORS=$OPTARG
		;;
	esac
done
#echo $AUTHORS
GIT_LOG_AUTHORS=""
author_num=1
dummy=1
while [ $dummy -le 2 ]
do
AUTHOR=$(echo $AUTHORS | cut -d ' ' -f $author_num)
#echo $AUTHOR
if [[ $AUTHOR == "" ]]; then
	break
else
	if [[ $GIT_LOG_AUTHORS == "" ]]; then
		GIT_LOG_AUTHORS="\("
	else
		GIT_LOG_AUTHORS="$GIT_LOG_AUTHORS\|\("
	fi
	GIT_LOG_AUTHORS="$GIT_LOG_AUTHORS$AUTHOR"
	GIT_LOG_AUTHORS="$GIT_LOG_AUTHORS\)"
	#let 'author_num += 1'
fi
AUTHORS=${AUTHORS//$AUTHOR}
done
#echo $GIT_LOG_AUTHORS
git log --author=$GIT_LOG_AUTHORS > git_log
result=$(grep "974727a4eedd5892dde4becbca923a1273e69c05" git_log2)
echo $result
if [[ $result == "" ]]; then
		result=""
		echo "commit not find"
	else
		echo "find commit"
	fi
