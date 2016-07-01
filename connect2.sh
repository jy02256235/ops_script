#!/bin/sh
Login_Name=$1
Login_Port=$2
ServerList_ihefe=$(dirname $0)/../connectmanager/srvlist_group_ihefe
ServerList_other=$(dirname $0)/../connectmanager/srvlist_group_wuling
Group_list=$(dirname $0)/../connectmanager/GroupList
ServerId_ihefe=($(awk 'NR!=1 {print $1}' ${ServerList_ihefe} ));
ServerIp_ihefe=($(awk 'NR!=1 {print $2}' ${ServerList_ihefe} ));
ServerId_other=($(awk 'NR!=1 {print $1}' ${ServerList_other} ));
ServerIp_other=($(awk 'NR!=1 {print $2}' ${ServerList_other} ));
ServerIp_port=($(awk 'NR!=1 {print $4}' ${ServerList_other} ));
Screen_Size=$(stty  size| awk '{print $NF}');
Define_Size=$((Screen_Size/2));
Text_Size=$((Define_Size/2));
Print_Context=(
#"Session Group List"
"Connect Manager Session Group List"
"Connect Manager Session Host List"
#"Session Host List"
);

function Authentication ()
{
read -p "User Authentication Filed: " -s UserPass 
echo
PassWord=$(cat "/Users/$(whoami)/.ssh/connectpass.p");
UserPass=$(echo ${UserPass} | md5);
if [[ "${UserPass}" != "${PassWord}" ]];then
echo "Authencation Failed"
return 130
fi
}
Context_Length()
{
case $1 in 
one)
	echo $((${#Print_Context[0]}/2))
	;;
two)	
	echo $((${#Print_Context[1]}/2))
	;;
esac
}
Cal_WinSize()
{
for i in $(seq 1 ${Define_Size});
do
	printf "+"
done
}
Print_Menu_Title()
{
Cal_WinSize
case $1 in
Main_Menu)
	printf "\n"
	for j in $(seq 1 $((${Text_Size}-$(Context_Length one))));
#	for j in $(seq 1 ${Text_Size});
		do
		printf " "
		done
		printf "${Print_Context[0]}"
	;;
Sub_Menu)
	printf "\n"
	for j in $(seq 1 $((${Text_Size}-$(Context_Length one))));
#	for j in $(seq 1 ${Text_Size});
		do
		printf " "
		done
		printf "${Print_Context[1]}"
	;;
esac
printf "\n"
Cal_WinSize
printf "\n"
}
while true;
do
	[ $# -lt 1 ] && echo "Usage:connect [username] Option [port]" && exit 128
	Print_Menu_Title Main_Menu
	cat $Group_list
	read -p "Choose a Group : " Select
		case $Select in
			1)
				clear
				Print_Menu_Title Sub_Menu
				cat $ServerList_ihefe
				read -p "Choose a Server ID (Press '[B]ack' to Return MainMenu): " i
				[ "$i" == "b" ] || [ "$i" == "B" ] && continue 
				[ ! -z "${Login_Port}" ] && ssh -o "ConnectTimeout 1" -p ${2} ${Login_Name}@${ServerIp_ihefe[$i-1]}
				ssh -o "ConnectTimeout 1" ${Login_Name}@${ServerIp_ihefe[$i-1]}
				[ ! "$?" == "0" ] && continue
			exit
			;;
			2)
#				Authentication
				[[ "$?" -eq 0 ]] || exit
				clear
				Print_Menu_Title Sub_Menu
				cat $ServerList_other
				read -p "Choose a Server ID (Press '[B]ack' to Return MainMenu): " i
				[ "$i" == "b" ] || [ "$i" == "B" ] && continue 
				[ ! -z "${Login_Port}" ] && ssh -o "ConnectTimeout 1" -p ${2} ${Login_Name}@${ServerIp_other[$i-1]} 				
				ssh -o "ConnectTimeout 1" -p${ServerIp_port[$i-1]} ${Login_Name}@${ServerIp_other[$i-1]}
				[ ! "$?" == "0" ] && continue


			exit
			;;
			3)
			;;
			4)
			;; 
		esac	
done
