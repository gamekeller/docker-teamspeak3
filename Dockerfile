###############################################
# Ubuntu with added Teamspeak 3 Server. 
# Optimised for use with a pre-applied custom config and a mysql database
###############################################

#If you're using a licence, be sure to add it to the config folder, before building the Image

# Using latest Ubuntu image as base
FROM ubuntu

MAINTAINER juri@schreib.at

## Set some variables for override.
# Teamspeak Version
ENV TEAMSPEAK_VERSION=3.0.11.3
# Download Link of TS3 Server
ENV TEAMSPEAK_URL=http://dl.4players.de/ts/releases/${TEAMSPEAK_VERSION}/teamspeak3-server_linux-amd64-${TEAMSPEAK_VERSION}.tar.gz

# Inject a Volume for any TS3-Data that needs to be persisted or to be accessible from the host. (e.g. for Backups)
VOLUME ["/teamspeak3"]

#Install needed libs
ADD http://ftp.de.debian.org/debian/pool/main/m/mariadb-client-lgpl/libmariadb2_2.0.0-1_amd64.deb /
RUN dpkg -i libmariadb2_2.0.0-1_amd64.deb

#Required env variable for Teamspeak to detect the lib
ENV LD_LIBRARY_PATH="/opt/teamspeak3-server_linux-amd64:"


# Download TS3 file and extract it into /opt.
ADD ${TEAMSPEAK_URL} /opt/
RUN cd /opt && tar -xzf /opt/teamspeak3-server_linux-amd64-${TEAMSPEAK_VERSION}.tar.gz

ENTRYPOINT ["/opt/teamspeak3-server_linux-amd64/ts3server_linux_amd64","inifile=/teamspeak3/ts3server.ini"]

# Expose the Standard TS3 port.
EXPOSE 9987/udp
# for files
EXPOSE 30033 
# for ServerQuery
EXPOSE 10011
