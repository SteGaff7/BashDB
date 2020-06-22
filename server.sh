#!/bin/bash
trap 'ctrl_c' INT
trap 'ctrl_z' SIGTSTP
ctrl_c() {
        rm server_pipe
        pkill -u $USER client.sh
        rm client_pipe* 2> /dev/null
	rm *[-lock$] 2> /dev/null
        exit 0
}
ctrl_z() {
        rm server_pipe
        pkill -u $USER client.sh
        rm client_pipe* 2> /dev/null
        rm *[-lock$] 2> /dev/null
        exit 0
}
mkfifo server_pipe
while true; do
read input < server_pipe
set -- $input
case "$2" in
        create_database)
                ./create_database.sh ${@:3} > client_pipe$1 &;;
        create_table)
                ./create_table.sh ${@:3} > client_pipe$1 &;;
        insert)
                ./insert.sh ${@:3} > client_pipe$1 &;;
        select)
                ./select.sh ${@:3} > client_pipe$1 &;;
       	shutdown)
		if [ "$1" = "admin" ]; then
			rm server_pipe
			echo "Server is shutting down." > client_pipe$1 &
			rm client_pipe* 2> /dev/null
                	rm *[-lock$] 2> /dev/null
                	pkill -u $USER client.sh
                	exit 0;
		else
			echo "Error: Permission denied, restricted to admin only.." > client_pipe$1 &
		fi;;
esac
done
