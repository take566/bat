pushd .
cd Squid\bin

.\squid.exe -z

schtasks /create /tn logrotate_squid /tr "Squid\bin\squid.exe -k rotate" /sc weekly /ST 00:00 /rl highest /F /NP