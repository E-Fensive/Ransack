# Ransack

Ransack Post Exploitation Tool v 0.1

Ransack's sole purpose is to grab any information deemed
relevant following a root compromise during an authorized
penetration test. This information may include config
files, ssh keys, ssl keys, or any other information
deemed valuable.

The goal is to minimize the amount of time spent digging
through a machine in search of specifics. Instead,
ransack will look for any data that stores configuration
information (which may at times contain usernames and
passwords), connection based information (including who
is connected to what, what processes are listening and
so forth), usernames and groups.

It is written specifically as a shell script to avoid
relying on another programming language that may not at
times be available on another system. Rather than having
to install python, perl, ruby, etc., it relies on tools
that are always on most modern and legacy Unix variants.
It will also parse out who may be what is considered at
high value target: Someone in a specific group (wheel,
root, etc) and copy over their information as well.

This tool is for post exploitation penetration testing
it is not meant to be used for nefarious purposes and
was never meant to be. It is simply a tool to make
gathering information simpler while performing
AUTHORIZED penetration tests.

If you have to ask: "How does it work?!?", "How can I
get r00t?!?", or some other question along these lines
there is a 99.99999% chance that there is an ID 10 T
error on the machine you're using. You will need to
fix that issue before proceeding.

Tested on various versions of FreeBSD, OpenBSD, Debian,
CentOS, Ubuntu, etc.

On FreeBSD/AMD Athlon(tm) 64 X2 Dual Core Processor
4400+ with 2TB, I was able to get all that I needed in
under 6 minutes. YMMV

On Linux
$ awk '/model name|MHz/' /proc/cpuinfo
model name      : AMD Phenom(tm) 9850 Quad-Core Processor
cpu MHz         : 2511.730
#
1 TB took 8 minutes
