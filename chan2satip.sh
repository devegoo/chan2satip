#!/bin/bash

# input and output filenames
INFILENAME=channels.conf
OUTFILENAME=chan_sat_ip_xml.xml

# SAT>IP server configuration
#IP=192.168.1.1.113
P1=
P1a=
P1b=
P1c=
P1d=
P2=S23.5E
P2a=S23.5E
P2b=S23.5E
P2c=S23.5E
P2d=S23.5E
P3=S28.5E
P3a=S28.5E
P3b=S19.2E
P3c=S28.5E
P3d=S28.5E
P4=S13.0E
P4a=S13.0E
P4b=S13.0E
P4c=S13.0E
P4d=S13.0E


# ? 
COUNT=10
EPAR=1

IFS=":"

if [ -f $OUTFILENAME ]; then
    rm $OUTFILENAME
fi
echo '<?xml version="1.0" encoding="UTF-8"?><channelTable msys="DVB-S">' >> $OUTFILENAME
while read NAME FREQ PAR SRC SR VPID APID TPID CAID SID NID TID RID
do
    if [ M$NAME == M ]
    then
	echo ":$FREQ" >> $OUTFILENAME 
	continue
    fi
    echo Name:$NAME Freq:$FREQ Par:$PAR Src:$SRC SR:$SR VPid:$VPID APid:$APID TPid:$TPID CAid:$CAID SID:$SID NID:$NID TID:$TID RID:$RID
#   Das Erste HD;ARD:11493:HC23M5O35P0S1:S19.2E:22000:5101=27:5102=deu@3,5103=mis@3;5106=deu@106:5104;5105=deu:0:10301:1:1019:0
    freq=$FREQ 
    sr=$SR

    case $SRC in
	$P1|$P1a|$P1b|$P1c|$P1d )
	    src=1 ;;
	$P2|$P2a|$P2b|$P2c|$P2d )
	    src=2 ;;
	$P3|$P3a|$P3b|$P3c|$P3d )
	    src=3 ;;
	$P4|$P4a|$P4b|$P4c|$P4d )
	    src=3 ;;
    esac


    echo $PAR | sed 's/\([A-Z]\)/\n\1/g' > par.txt
    while read P
    do
	if [ M$P != "M" ]
	then
	    KEY=`echo $P | sed 's/\([A-Z]\)/\1 /g' | awk '{print $1}'`
	    NUM=`echo $P | sed 's/\([A-Z]\)/\1 /g' | awk '{print $2}'`
#	    echo $KEY $NUM

	    case $KEY in
		H )
	    	pol=h ;;
		V )
		    pol=v ;;
		O )
    		ro=$NUM ;;
		M )
		    case $NUM in
			2 )
			mtype=QPSK ;;   
            		5 )
			mtype=8PSK ;;   
            		6 )
			mtype=16APSK ;; 
            		7 )
			mtype=32APSK ;; 
            		10 )
			mtype=VSB8 ;;   
            		11 )
			mtype=VSB16 ;;  
            		12 )
			mtype=DQPSK ;;  
            		16 )
			mtype=QAM16 ;;  
            		32 )
			mtype=QAM32 ;;
            		64 )
			mtype=QAM64 ;;  
            		128 )
			mtype=QAM128 ;; 
            		256 )
			mtype=QAM256 ;; 
		    esac
		    ;;
		S )
		    if [ $NUM == 0 ]
		    then
			msys=dvbs
		    else
			msys=dvbs2
		    fi 
		    ;;
		T )
			if [ $NUM == 8 ]
		    then
			msys=dvbt
		    else
			msys=dvbt2
		    fi 
		    ;;
		C )
		    fec=$NUM ;;
	    esac
	fi


    done<par.txt
    rm -f par.txt
if [ M$NAME == M ]
numer=$(("numer+1"))
    then
    # DVB-S satellite string to sources number


    echo "<channel number=\""$numer"\"><tuneType>DVB-S-AUTO</tuneType><visible>true</visible><type>tv</type><name>${NAME}</name><freq>${FREQ}</freq><pol>$pol</pol><sr>${SR}</sr><src>$src</src><pids>${VPID},${APID}</pids></channel>" >> $OUTFILENAME
	continue
    fi
    #pids=`echo ""$VPID";"$APID" | sed 's/[,;]/\n/g' | awk -F"=" '{print $1}' | awk '{if(NR>1)printf",%s",$1; else printf"%s",$1}END{printf"\n"}'`
#    echo $APID | sed 's/[,;]/\n/g'

#    echo src=$src freq=$freq pol=$pol ro=$ro mtype=$mtype msys=$msys sr=$sr fec=$fec pids=$pids

   # echo "$NAME http://${IP}/?src=$src\&freq=$freq\&pol=$pol\&ro=$ro\&mtype=$mtype\&msys=$msys\&sr=$sr\&fec=$fec\&pids=$pids"
#    echo "$NAME http://192.168.168.37/?src=$src&freq=$freq&pol=$pol&ro=$ro&mtype=$mtype&msys=$msys&sr=$sr&fec=$fec&pids=$pids"
#    echo "$NAME http://192.168.168.37/%3Fsrc=$src%26freq=$freq%26pol=$pol%26ro=$ro%26mtype=$mtype%26msys=$msys%26sr=$sr%26fec=$fec%26pids=$pids"
    SRC=I


#    PAR=`echo "S=1|P=1|F=HTTP|U=192.168.168.37/%3Fsrc=$src%26freq=$freq%26pol=$pol%26ro=$ro%26mtype=$mtype%26msys=$msys%26sr=$sr%26fec=$fec%26pids=$pids|A=80"`
#    PAR=`echo "S=1|P=1|F=HTTP|U=192.168.168.37/?src=$src&freq=$freq&pol=$pol&ro=$ro&mtype=$mtype&msys=$msys&sr=$sr&fec=$fec&pids=$pids|A=80"`
#    PAR=`echo "S=1|P=1|F=CURL|U=http%3A//${IP}/?src=$src&freq=$freq&pol=$pol&ro=$ro&mtype=$mtype&msys=$msys&sr=$sr&fec=$fec&pids=$pids|A=$APAR"`
   # PAR=`echo "http%3A//${IP}/?src=$src&freq=$freq&pol=$pol&ro=$ro&mtype=$mtype&msys=$msys&sr=$sr&fec=$fec&pids=$pids"`

    FREQ=$COUNT

    COUNT=`expr $COUNT + 10` 
    APAR=`expr $APAR + 1` 
    #echo ${NAME}:${FREQ}:${PAR}:${SRC}:${SR}:${VPID}:${APID}:${TPID}:${CAID}:${SID}:${NID}:${TID}:${RID} >> $OUTFILENAME 
	#echo ${NAME}:${FREQ}:${PAR}:${SRC}:${SR}:${VPID}:${APID}:${TPID}:${CAID}:${SID}:${NID}:${TID}:${RID} >> $OUTFILENAME 
	echo -e "#${NAME}\n${PAR}">> $OUTFILENAME
#exit

done<$INFILENAME 
echo '</channelTable>' >> $OUTFILENAME
