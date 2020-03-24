pathx=echo $PATH|grep "/sbin"
if [ “” = “$pathx” ]; then
   export PATH=$PATH:/sbin
   echo “no sbin”
fi


/root/udp/udp2raw_amd64 -s -l 0.0.0.0:27015 -r 127.0.0.1:27010 -k maintell --raw-mode faketcp -a >> /root/udp/log.txt 2>&1 &
