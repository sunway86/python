project_name=website
svn_username=admin
svn_url=http://58.1.1.1.1:6666/usvn/svn/$project_name
web_path=/home/wwwroot/website/$project_name
if [ ! -d $web_path ];then
mkdir -p $web_path
fi
function deploy(){
/usr/bin/svn co -q --username  $svn_username --password 12345678  $svn_url $web_path
cd $web_path
/usr/bin/svn up
echo "deploy $project_name sucessful!"
}
rollback() {
  cd ${web_path}
  svn_no=$(svn info |grep "Last Changed Rev" |awk '{print $4}')
  svn merge -r $svn_no:`expr $svn_no - 1` ${svn_url}
  svn commit -m "Revert revision from ${svn_no} to rollback"
  svn up
  echo "rollback to ${svn_no}"
  exit 0

}

case $1 in
rollback)
        rollback
;;
deploy)
        deploy
;;
*)
echo "Useage:$0 rollback"
exit 0
;;
esac
