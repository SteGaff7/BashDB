#!/bin/bash
ctrl_c() {
	rm client_pipe$1
	exit 0
}
ctrl_z() {
        rm client_pipe$1
        exit 0
}
trap 'ctrl_c $1' INT
trap 'ctrl_z $1' SIGTSTP

if [ $# -eq 1 ]; then
	if ! [ -e "client_pipe$1" ]; then
		 mkfifo client_pipe$1
	else
		echo "Error: This client ID is already in use."
		exit 13
	fi
	while [ -p server_pipe ]; do
		echo "Enter your request(Type 'exit' to exit):"
		read userinput
		arr=( $userinput )
		request=${arr[0]}
		if [ "$request" = "create_database" ] || [ "$request" = "create_table" ] || [ "$request" = "insert" ] || [ "$request" = "select" ] || [ "$request" = "shutdown" ]; then
			echo $1 $userinput > server_pipe
		elif [ "$request" = "exit" ]; then
			echo "User exited..."
			rm client_pipe$1
			exit 0
		else
			echo "Error: Bad request, try again, acceptable requests are: create_database, create_table, insert, select, exit."
			continue
		fi
		grep -v "start_result\|end_result" < client_pipe$1;
	done
else
	echo "Error: enter only one parameter, client ID number."
	exit 11
fi
