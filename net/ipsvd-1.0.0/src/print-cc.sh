cc="`head -n1 conf-cc`"
cat warn-auto.sh
echo exec "$cc" '-c ${1+"$@"}'
