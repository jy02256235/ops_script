#!/bin/sh
Login_Name=$1
UsingMethod=$2
scp_mode=$3
Current_Path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
Group_list=${Current_Path}/Grouplist
Screen_Size=$(stty  size| awk '{print $NF}');
Define_Size=$((Screen_Size/2));
Text_Size=$((Define_Size/2));
Print_Context=(
#"Session Group List"
"Connect Manager Session Group List"
"Connect Manager Session Host List"
#"Session Host List"
);
function usage ()
{
	echo "Usage:connect [username] Option [port] Option [SSH_Feature scp] arg [c2s|s2c] "
}

function ProfileGen()
{
	local File_Select=$1
	ServerList="${Current_Path}/srvlist_group_${File_Select}"
	ServerId=($(awk 'NR!=1 {print $1}' ${ServerList} ));
	ServerIp=($(awk 'NR!=1 {print $2}' ${ServerList} ));
	ServerPort=($(awk 'NR!=1 {print $4}' ${ServerList} ));

}

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
			do
			printf " "
			done
			printf "${Print_Context[0]}"
		;;
	Sub_Menu)
		printf "\n"
		for j in $(seq 1 $((${Text_Size}-$(Context_Length one))));
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
function SSH_Feature ()
{

	local CommandMethod=$1

	while true;
	do
		[ $# -lt 1 ] && usage && exit 128
		Print_Menu_Title Main_Menu
		cat $Group_list
		read -p "Choose a Group : " Select
			case $Select in
				1)
					ProfileGen ihefe
					clear
					Print_Menu_Title Sub_Menu
					cat $ServerList
					read -p "Choose a Server ID (Press '[B]ack' to Return MainMenu): " i
					[ "$i" == "b" ] || [ "$i" == "B" ] && continue 
					ARGV_Process
					[ ! "$?" == "0" ] && continue
				exit
				;;
				2)
					ProfileGen wuling
	#				Authentication
					[[ "$?" -eq 0 ]] || exit
					clear
					Print_Menu_Title Sub_Menu
					cat $ServerList
					read -p "Choose a Server ID (Press '[B]ack' to Return MainMenu): " i
					[ "$i" == "b" ] || [ "$i" == "B" ] && continue  				
#					ssh -o "ConnectTimeout 1" -p${ServerPort[$i-1]} ${Login_Name}@${ServerIp[$i-1]}
					ARGV_Process
					[ ! "$?" == "0" ] && continue


				exit
				;;
				3)
				;;
				4)
				;; 
			esac	
	done
}

ARGV_Process()
{
	if [[ -z "${UsingMethod}" ]];then
		ssh -o "ConnectTimeout 1" -p${ServerPort[$i-1]} ${Login_Name}@${ServerIp[$i-1]}
	else
		 [[ -z "${scp_mode}" ]]  && usage && exit 129
		read -p "Enter Destination File Path(e.g:/usr/local/bin/...): " DestinationFile
		read -p "Enter Source File Path(e.g:/localhost/...): " SourceFile
			if [[ "${scp_mode}" == "c2s" ]];then
				scp -o "ConnectTimeout 1" -P${ServerPort[$i-1]} ${SourceFile} ${Login_Name}@${ServerIp[$i-1]}:${DestinationFile}
			elif [[ "${scp_mode}" == "s2c" ]];then
				scp -o "ConnectTimeout 1" -P${ServerPort[$i-1]} ${Login_Name}@${ServerIp[$i-1]}:${DestinationFile} ${SourceFile}
			fi
								
	fi
}
SSH_Feature ${Login_Name} ${UsingMethod} ${scp_mode}