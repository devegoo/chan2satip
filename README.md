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


SAT>IP Source Number : This field is matched through the “src” parameter asked from the SAT>IP client. Usually (and by default) this value is 1. For satellite tuners, this value determines the satellite source (dish). By specification position 1 = DiseqC AA, 2 = DiseqC AB, 3 = DiseqC BA, 4 = DiseqC BB, but any numbers may be used - depends on the SAT>IP client. Note that if you use same number for multiple networks, the first matched network containing the mux with requested parameters will win (also for unknown mux). If this field is set to zero, the network cannot be used by the SAT>IP server.
