Module_Name=$(git config --get core.module)
read -p "$Module_Name: " title_str
read -p "Rootcause: " comment_str
read -p "Ticket: " ticket
echo $comment_str > f_comment
par < f_comment > f_comment_par
Title_Line="$Module_Name: "
Commit_msg="$Module_name$title"
echo $Commit_msg > .commit_msg
echo "" >> .commit_msg
echo "$Module_Name: $title_str" > title_f
echo "" >> title_f
cat title_f f_comment_par > f_msg
echo "" >> f_msg
echo "Ticket: $ticket" >> f_msg
echo "" >> f_msg
#echo "Signed-off-by:" >> f_msg
Name=$(git config --get user.name)
Email=$(git config --get user.email)
echo $Email
echo "Signed-off-by: $Name <$Email>" >> f_msg

cat f_msg
git commit -F f_msg
