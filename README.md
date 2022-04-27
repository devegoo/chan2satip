# chan2satip(triax tss400 DLNA)
#
mod for triax tss400 dlna playlist

edit script for your satip multi diseqc(1/4) setup /for connected sat positions diseqc = a b c d ports =  1.2.3.4

put all configured postions channels_1,1a,2b,3c,4d.2,2a,2c,2d,3,3a,3b,3c,3d,4,4a,4b,4c,4d.conf files to source folder

and merge to one

cat channels*.conf > channels.conf

then

run 

./chan2satip.sh

chan_sat_ip_xml.xml is output file after processing
