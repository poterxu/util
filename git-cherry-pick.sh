#===============================================================================
#
#          FILE: git-cherry-pick.sh
# 
#         USAGE: ./git-cherry-pick.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 11/27/2014 18:44
#      REVISION:  ---
#===============================================================================

#set -o nounset                              # Treat unset variables as an error

AUTHOR=""
#-----------------------
#PROCESS COMMAND OPTIONS
#-----------------------

while getopts "a:b:" opt; do
        case $opt in
        a)
                AUTHORS=$OPTARG
        ;;
	b)
		base_branch=$OPTARG
	;;
               esac
done
#echo $base_branch

#echo $AUTHORS
GIT_LOG_AUTHORS=""
author_num=1
dummy=1
patch_skipped=0
patch_merged=0
patch_total=0

#---  FUNCTION  ----------------------------------------------------------------
#          NAME:  get_multiple_authors
#   DESCRIPTION:  
#    PARAMETERS:  
#       RETURNS:  
#-------------------------------------------------------------------------------
while [ $dummy -le 2 ]
do
	AUTHOR=$(echo $AUTHORS | cut -d ' ' -f $author_num)
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

git log --author=$GIT_LOG_AUTHORS $base_branch > .git_log
#patch_total=$(git log --author=$GIT_LOG_AUTHORS $base_branch --pretty=format:"" | wc -l)
git log --author=$GIT_LOG_AUTHORS > .target_branch_git_log
line_num=$(wc -l .git_log | awk '{print $1}')
n=10

while [ $n -eq 10 ] 
do	
	one_line_log=$(head -n $line_num .git_log | tail -1)
	is_commit=$(echo $one_line_log | awk '{print $1}')
	
	if [[ $is_commit == "commit" ]]; then
	
		#echo $one_line_log
		et 'patch_total += 1'
	
		commit_id=$(echo $one_line_log | awk '{print $2}')
		git log --format=%B -n 1 $commit_id > .git_log_msg
		change_id_line=$(grep "Change-Id:" .git_log_msg)
		change_id=$(echo $change_id_line | awk '{print $2}')
		#echo $change_id	

	

		result=$(grep $change_id .target_branch_git_log)
		if [[ $result == "" ]]; then
			echo ""
			echo ""
			git cherry-pick $commit_id 
			exit_code=$?
			echo ""
			echo ""
			if [[ $exit_code == 0 ]]; then
				exit_code=$?
		 
			else
				read -p "cherry pick failed, fix it in another shell then Press any key continue..." cmd_line
				$cmd_line
				#let 'patch_merged += 1'
			fi
			let 'patch_merged += 1'

	
		else
			let 'patch_skipped += 1'
			echo "Patch already merged, Skip..."
			
		fi	
	fi 
	
	if [[ $line_num -eq 0 ]]; then
		break
	fi
	
	let "line_num -= 1"
done
echo "$patch_total patch total"
echo "$patch_skipped patch skipped "
echo "$patch_merged patch merged"

#---  FUNCTION  ----------------------------------------------------------------
#          NAME:  rm_intermediate_files
#   DESCRIPTION:  
#    PARAMETERS:  
#       RETURNS:  
#-------------------------------------------------------------------------------
if [ -f ".git_log" ]; then
rm .git_log
fi
if [ -f ".git_log_msg" ]; then
rm .git_log_msg
fi

if [ -f ".target_branch_git_log" ]; then
rm .target_branch_git_log
fi
