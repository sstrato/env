#!/bin/bash
SCREENNAME=$@
NL=`echo -ne '\015'`

function usage() {
	echo "`basename $0` screen [session]"
	echo
	echo "session"
	echo "  andrew"
	echo "	devstack"
}

case "$SCREENNAME" in
	"andrew")
		hosts="c-node26/c-node25 c-node27/c-node27 c-node28/c-node28 c-node29/c-node29 c-node30/c-node30" 
		;;
	"devstack")
		hosts="pxe/10.20.1.3 chef/10.20.1.5 control/10.20.1.80 network/10.40.1.80 compute/10.30.1.80"
		;;
	*)
		usage
		exit
esac

if screen -ls | egrep -q "[0-9].$SCREENNAME"; then
	echo "screen named $SCREEN_NAME already exists"
	exit
fi

screen -d -m -S $SCREENNAME -t shell
sleep 1

for spec in $hosts; do
	name=`echo "$spec" | cut -d '/' -f 1`
	host=`echo "$spec" | cut -d '/' -f 2`

	screen -S $SCREENNAME -X screen -t "$name"
	screen -S $SCREENNAME -p "$name" -X stuff "sshpass -pcloud123go ssh cloud@$host$NL"
done

echo "please run 'screen -r $SCREENNAME'"

# vim: nu ai ts=4 sw=4
