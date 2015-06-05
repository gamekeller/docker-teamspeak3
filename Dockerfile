###############################################
# Ubuntu with added Teamspeak 3 Server. 
# Optimised for use with a mariadb database
###############################################

#If you're using a licence, be sure to add it to the config folder, before building the Image

# Using latest Ubuntu image as base
FROM ubuntu

MAINTAINER juri@schreib.at

## Set some variables for override.
# Teamspeak Version
ENV TEAMSPEAK_VERSION=3.0.11.3
# Mariadb Connector Version
ENV MARIADB_CONNECTOR_VERSION=2.1.0
# Download Link of TS3 Server
ENV TEAMSPEAK_URL=http://dl.4players.de/ts/releases/${TEAMSPEAK_VERSION}/teamspeak3-server_linux-amd64-${TEAMSPEAK_VERSION}.tar.gz
#Donwload Link for Mairadb-Connector
ENV MARIADB_CONNECTOR_URL=https://downloads.mariadb.org/f/connector-c-${MARIADB_CONNECTOR_VERSION}/bintar-linux-x86_64/mariadb-connector-c-${MARIADB_CONNECTOR_VERSION}-linux-x86_64.tar.gz

#Required env variable for Teamspeak to detect the lib
ENV LD_LIBRARY_PATH="/opt/teamspeak3-server_linux-amd64:"

# Inject a Volume for any TS3-Data that needs to be persisted or to be accessible from the host. (e.g. for Backups)
VOLUME ["/teamspeak3"]

#Download and install required Files
ADD ${MARIADB_CONNECTOR_URL} /opt/
ADD ${TEAMSPEAK_URL} /opt/
RUN cd /opt/ && tar -xzf mariadb-connector-c-${MARIADB_CONNECTOR_VERSION}-linux-x86_64.tar.gz && \
	tar -xzf teamspeak3-server_linux-amd64-${TEAMSPEAK_VERSION}.tar.gz && \
	mv /opt/mariadb-connector-c-${MARIADB_CONNECTOR_VERSION}-linux-x86_64/lib/mariadb/libmariadb.so.2 /opt/teamspeak3-server_linux-amd64/ && \
	rm /opt/*.tar.gz

ENTRYPOINT ["/opt/teamspeak3-server_linux-amd64/ts3server_linux_amd64","inifile=/teamspeak3/ts3server.ini"]

# Expose the Standard TS3 port.
EXPOSE 9987/udp
# for files
EXPOSE 30033 
# for ServerQuery
EXPOSE 10011
# for tsdns
EXPOSE 41144
