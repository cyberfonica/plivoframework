FROM ubuntu:14.04

#  Install dependencies
RUN apt-get clean && apt-get update && apt-get install -y \
    autoconf automake autotools-dev binutils bison build-essential cpp curl flex g++ gcc git-core libaudiofile-dev libc6-dev libdb-dev libexpat1 libgdbm-dev libgnutls-dev libmcrypt-dev libncurses5-dev libnewt-dev libpcre3 libpopt-dev libsctp-dev libsqlite3-dev libtiff5 libtiff5-dev libtool libx11-dev libxml2 libxml2-dev lksctp-tools lynx m4 make mcrypt ncftp nmap openssl sox sqlite3 ssl-cert ssl-cert unixodbc-dev unzip zip zlib1g-dev zlib1g-dev libevent-dev git-core python-setuptools python-dev build-essential python-pip unifdef cython

# Install python deps
COPY requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

#  Copy plivo sources
COPY src/ /opt/plivo/src/

# Config files
COPY src/config/default.conf /etc/plivo/default.conf
COPY src/config/cache.conf /etc/plivo/cache.conf

COPY scripts/entrypoint.sh /entrypoint.sh

# Plivo Outbound server. (Freeswitch -> Plivo)
EXPOSE 8084

# Plivo Cache server. (Plivo -> Cache)
EXPOSE 8089

ENTRYPOINT ["/entrypoint.sh"]
