FROM alpine:latest

ENV SOFTETHER_REPO https://github.com/SoftEtherVPN/SoftEtherVPN.git
ENV SOFTETHER_REPO_API https://api.github.com/repos/SoftEtherVPN/SoftEtherVPN/releases/latest
ENV S6_VERSION 1.21.8.0

# Install s6 overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-amd64.tar.gz /tmp/
RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C /

RUN apk --no-cache --no-progress update && \
  apk --no-cache --no-progress upgrade && \
  # Install s6 supervisor
  apk --no-cache --no-progress add bash && \
  mkdir -p /etc/services.d && mkdir -p /etc/cont-init.d && mkdir -p /s6-bin && \
  # Install build dependencies
  apk --no-cache --no-progress --virtual .build-deps add git libgcc libstdc++ gcc musl-dev libc-dev g++ ncurses-dev \
  readline-dev openssl-dev cmake make zlib-dev curl && \
  # Grab and build Softether from GitHub
  git clone ${SOFTETHER_REPO} /tmp/softether && \
  cd /tmp/softether && git submodule init && git submodule update && export USE_MUSL=YES && \
  # Get latest Tag
  cd /tmp/softether && export TRACK_LATEST=$(curl --silent ${SOFTETHER_REPO_API} | grep "tag_name" | sed -r 's/.*(".*").*"(.*)".*/\2/g') && \
  # Checkout Latest Tag
  git checkout ${TRACK_LATEST} && git submodule init && git submodule update && export USE_MUSL=YES && \
  # Build
  ./configure && make --silent -C tmp && make --silent -C tmp install &&  \
  cp /tmp/softether/build/libcedar.so /tmp/softether/build/libmayaqua.so /usr/lib && \
  # Removing build extensions
  apk del .build-deps && apk del --no-cache --purge && \
  rm -rf /tmp/softether && rm -rf /var/cache/apk/* && \
  # Deleting unncessary extensions
  rm -rf /usr/local/bin/vpnbridge /usr/local/bin/vpnserver \
  /usr/local/libexec/softether/vpnbridge /usr/local/libexec/softether/vpnserver && \
  # Reintroduce necassary libraries
  apk add --no-cache --virtual .run-deps \
  libcap libcrypto1.1 libssl1.1 ncurses-libs readline su-exec dhclient && \
  # Link Libraries to Binary
  mkdir /s6-bin/softether-vpncli && \
  ln -s /usr/local/bin/vpnclient /s6-bin/softether-vpncli/vpnclient && \
  ln -s /usr/local/bin/vpncmd /s6-bin/softether-vpncli/vpncmd && \
  # Link the connection profile as well since there is a bug with importing from directory
  apk add --no-cache expect && \
  # Install SAMBA Daemon
  apk --no-cache --no-progress add samba && \
  # Create SAMBA User
  adduser -D -G users -H -S -g 'Samba User' -h /tmp smbuser && \
  # Initiate Samba Configuration File
  file="/etc/samba/smb.conf" && \
  sed -i 's|^;* *\(log file = \).*|   \1/dev/stdout|' $file && \
  sed -i 's|^;* *\(load printers = \).*|   \1no|' $file && \
  sed -i 's|^;* *\(printcap name = \).*|   \1/dev/null|' $file && \
  sed -i 's|^;* *\(printing = \).*|   \1bsd|' $file && \
  sed -i 's|^;* *\(unix password sync = \).*|   \1no|' $file && \
  sed -i 's|^;* *\(preserve case = \).*|   \1yes|' $file && \
  sed -i 's|^;* *\(short preserve case = \).*|   \1yes|' $file && \
  sed -i 's|^;* *\(default case = \).*|   \1lower|' $file && \
  sed -i '/Share Definitions/,$d' $file && \
  echo '   pam password change = yes' >>$file && \
  echo '   map to guest = bad user' >>$file && \
  echo '   usershare allow guests = yes' >>$file && \
  echo '   create mask = 0664' >>$file && \
  echo '   force create mode = 0664' >>$file && \
  echo '   directory mask = 0775' >>$file && \
  echo '   force directory mode = 0775' >>$file && \
  echo '   force user = smbuser' >>$file && \
  echo '   force group = users' >>$file && \
  echo '   follow symlinks = yes' >>$file && \
  echo '   load printers = no' >>$file && \
  echo '   printing = bsd' >>$file && \
  echo '   printcap name = /dev/null' >>$file && \
  echo '   disable spoolss = yes' >>$file && \
  echo '   socket options = TCP_NODELAY' >>$file && \
  echo '   strict locking = no' >>$file && \
  echo '   vfs objects = acl_xattr catia fruit recycle streams_xattr' >>$file && \
  echo '   recycle:keeptree = yes' >>$file && \
  echo '   recycle:versions = yes' >>$file && \
  echo '' >>$file && \
  echo '   # Security' >>$file && \
  echo '   client ipc max protocol = default' >>$file && \
  echo '   client max protocol = default' >>$file && \
  echo '   server max protocol = SMB3' >>$file && \
  echo '   client ipc min protocol = default' >>$file && \
  echo '   client min protocol = CORE' >>$file && \
  echo '   server min protocol = SMB2' >>$file && \
  echo '' >>$file && \
  echo '   # Time Machine' >>$file && \
  echo '   durable handles = yes' >>$file && \
  echo '   kernel oplocks = no' >>$file && \
  echo '   kernel share modes = no' >>$file && \
  echo '   posix locking = no' >>$file && \
  echo '   fruit:aapl = yes' >>$file && \
  echo '   fruit:advertise_fullsync = true' >>$file && \
  echo '   fruit:time machine = yes' >>$file && \
  echo '   smb2 leases = yes' >>$file && \
  echo '' >>$file && \
  # Clean Up Files
  rm -rf /tmp/*

# Create default configuration folders
RUN mkdir -p /scripts

# Copy scripts
ADD https://gist.githubusercontent.com/cenk1cenk2/e03d8610534a9c78f755c1c1ed93a293/raw/28b96c2e3d6150cb0adc4489c87c7a1658747d0f/logger.sh /scripts/logger.sh

RUN chmod +x /scripts/*.sh

# Expose samba ports
EXPOSE 139 445

# Move s6 supervisor files inside the container
COPY ./services.d /etc/services.d

RUN chmod +x /etc/services.d/*/*.sh

# s6 behaviour, https://github.com/just-containers/s6-overlay
ENV S6_KEEP_ENV 1
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS 2
ENV S6_FIX_ATTRS_HIDDEN 1

ENTRYPOINT ["/init"]
