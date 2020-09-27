/root/udp/udp2raw_amd64 -s -l 0.0.0.0:27015 -r 127.0.0.1:27010 -k maintell --raw-mode faketcp -a --cipher-mode none --auth-mode none --disable-anti-replay --seq-mode 0 >> /root/udp/log.txt 2>&1 &
