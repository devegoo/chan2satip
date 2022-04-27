#!/bin/bash

# input and output filenames
INFILENAME=channels.conf
OUTFILENAME=chan_sat_ip_xml.xml

# SAT>IP server configuration
#IP=192.168.1.1.113


# DVB-S satellite string to sources number
DVBS_SOURCE1=S19.2E	#1 if one
DVBS_SOURCE1a=S19.2E		#1a
DVBS_SOURCE1b=S19.2E
DVBS_SOURCE1c=S19.2E
DVBS_SOURCE1d=S19.2E
DVBS_SOURCE2=S23.5E	#2 if one
DVBS_SOURCE2a=S23.5E
DVBS_SOURCE2b=S23.5E		#2b
DVBS_SOURCE2c=S23.5E
DVBS_SOURCE2d=S23.5E
DVBS_SOURCE3=S28.5E	#3 if one
DVBS_SOURCE3a=S28.5E
DVBS_SOURCE3b=S28.5E
DVBS_SOURCE3c=S28.5E
DVBS_SOURCE3d=S28.5E		#3c
DVBS_SOURCE4=S13.0E	#4 if one
DVBS_SOURCE4a=S13.0E
DVBS_SOURCE4b=S13.0E
DVBS_SOURCE4c=S13.0E
DVBS_SOURCE4d=S13.0E		#4d

# ? 
COUNT=10
EPAR=1

IFS=":"

if [ -f $OUTFILENAME ]; then
    rm $OUTFILENAME
fi
echo "<?xml version="1.0" encoding="UTF-8"?><channelTable msys="DVB-S">" >> $OUTFILENAME
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

        declare -a Pos1
		Pos1=(1 1a 1b 1c 1d)
    	declare -a Src
		Src1=1
		declare -a Pos2
		Pos2=(2 2a 2b 2c 2d)
    	declare -a Src
		Src2=2
		declare -a Pos3
		Pos3=(3 3a 3b 3c 3d)
    	declare -a Src
		Src3=3
		declare -a Pos4
		Pos4=(4 4a 4b 4c 4d)
    	declare -a Src4
		Src4=4
    case $SRC in
	$DVBS_SOURCE$Pos1 )
	    src=$Src1 ;;
    esac
    case $SRC in
	$DVBS_SOURCE$Pos2 )
	    src=$Src2 ;;
    esac
    case $SRC in
	$DVBS_SOURCE$Pos3 )
	    src=$Src3 ;;
    esac
    case $SRC in
	$DVBS_SOURCE$Pos4 )
	    src=$Src4 ;;
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
    echo "<channel number=\""$numer"\"><tuneType>DVB-S-AUTO</tuneType><visible>true</visible><type>tv</type><name>${NAME}</name><freq>${FREQ}</freq><pol>$pol</pol><sr>${SR}</sr><src>1</src><pids>${VPID},${APID}</pids></channel>" >> $OUTFILENAME
	continue
    fi
    pids=`echo "0,18,"$VPID";"$APID","$TPID | sed 's/[,;]/\n/g' | awk -F"=" '{print $1}' | awk '{if(NR>1)printf",%s",$1; else printf"%s",$1}END{printf"\n"}'` 
#    echo $APID | sed 's/[,;]/\n/g'

#    echo src=$src freq=$freq pol=$pol ro=$ro mtype=$mtype msys=$msys sr=$sr fec=$fec pids=$pids

    echo "$NAME http://${IP}/?src=$src\&freq=$freq\&pol=$pol\&ro=$ro\&mtype=$mtype\&msys=$msys\&sr=$sr\&fec=$fec\&pids=$pids"
#    echo "$NAME http://192.168.168.37/?src=$src&freq=$freq&pol=$pol&ro=$ro&mtype=$mtype&msys=$msys&sr=$sr&fec=$fec&pids=$pids"
#    echo "$NAME http://192.168.168.37/%3Fsrc=$src%26freq=$freq%26pol=$pol%26ro=$ro%26mtype=$mtype%26msys=$msys%26sr=$sr%26fec=$fec%26pids=$pids"
    SRC=I


#    PAR=`echo "S=1|P=1|F=HTTP|U=192.168.168.37/%3Fsrc=$src%26freq=$freq%26pol=$pol%26ro=$ro%26mtype=$mtype%26msys=$msys%26sr=$sr%26fec=$fec%26pids=$pids|A=80"`
#    PAR=`echo "S=1|P=1|F=HTTP|U=192.168.168.37/?src=$src&freq=$freq&pol=$pol&ro=$ro&mtype=$mtype&msys=$msys&sr=$sr&fec=$fec&pids=$pids|A=80"`
#    PAR=`echo "S=1|P=1|F=CURL|U=http%3A//${IP}/?src=$src&freq=$freq&pol=$pol&ro=$ro&mtype=$mtype&msys=$msys&sr=$sr&fec=$fec&pids=$pids|A=$APAR"`
    PAR=`echo "http%3A//${IP}/?src=$src&freq=$freq&pol=$pol&ro=$ro&mtype=$mtype&msys=$msys&sr=$sr&fec=$fec&pids=$pids"`

    FREQ=$COUNT

    COUNT=`expr $COUNT + 10` 
    APAR=`expr $APAR + 1` 
    #echo ${NAME}:${FREQ}:${PAR}:${SRC}:${SR}:${VPID}:${APID}:${TPID}:${CAID}:${SID}:${NID}:${TID}:${RID} >> $OUTFILENAME 
	#echo ${NAME}:${FREQ}:${PAR}:${SRC}:${SR}:${VPID}:${APID}:${TPID}:${CAID}:${SID}:${NID}:${TID}:${RID} >> $OUTFILENAME 
	echo -e "#${NAME}\n${PAR}">> $OUTFILENAME
#exit

done<$INFILENAME 
echo "</channelTable>" >> $OUTFILENAME
