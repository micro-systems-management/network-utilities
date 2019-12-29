
export a=''
export b=''
export datetime=$(date +%Y%m%d_%H%M%S)
if ! [[ -d ~/bin/test/$datetime ]] ; then
	mkdir ~/bin/test/$datetime/tmp -p
	mkdir ~/bin/test/$datetime/archive -p
	cp -f ./scriptedping.sh ~/bin/test/
	chmod +x ~/bin/test/scriptedping.sh
else
	cp -f ./scriptedping.sh ~/bin/test/
	chmod +x ~/bin/test/scriptedping.sh
fi
screen -d -m -S test1 bash -c 'ping $a | while read pong; do echo "$(date): $pong"; done > ~/bin/test/$datetime/tmp/box_Network-ping-$a-$datetime.log.tmp'
screen -d -m -S test2 bash -c 'ping $b | while read pong; do echo "$(date): $pong"; done > ~/bin/test/$datetime/tmp/box_Network-ping-$b-$datetime.log.tmp'
sleep 10
screen -XS test1 quit
screen -XS test2 quit	
test1=$(awk -F'time=|ms' '{if($2>200)print$0}' <~/bin/test/$datetime/tmp/box_Network-ping-$a-$datetime.log.tmp)
test2=$(awk -F'time=|ms' '{if($2>200)print$0}' <~/bin/test/$datetime/tmp/box_Network-ping-$b-$datetime.log.tmp)
if [[ "$test1" ]] || [[ "$test2" ]] ; then
	mv ~/bin/test/$datetime/tmp/box_Network-ping-$a-$datetime.log.tmp ~/bin/test/$datetime/archive/box_Network-ping-$a-$datetime.log
	mv ~/bin/test/$datetime/tmp/box_Network-ping-$b-$datetime.log.tmp ~/bin/test/$datetime/archive/box_Network-ping-$b-$datetime.log
	traceroute $a > ~/bin/test/$datetime/archive/traceroute-$a-$(date +%Y%m%d_%H%M%S).log
	traceroute $b > ~/bin/test/$datetime/archive/traceroute-$b-$(date +%Y%m%d_%H%M%S).log
else
	rm -r ~/bin/test/$datetime
fi