require recipes-core/images/core-image-minimal.bb
#altera recipe uses this line below instead of line above
#require recipes-core/images/core-image-base.bb
#this is in altera image recipe; delete this comment after you look this up to know what it does
#require core-image-essential.inc

IMAGE_FEATURES += "allow-empty-password empty-root-password"

IMAGE_INSTALL += " \
	bash \
	connman \
	devmem2 \
	e2fsprogs \
	ethtool \
	fio \
	gcc \
	gdb \
	gdbserver \
	git \
	gnuplot \
	i2c-tools \
	iperf3 \
	iw \
	kernel-dev \
	kernel-image \
	kernel-modules \
	libiio \
	libiio-iiod \
	libiio-tests \
	lighttpd \
	lighttpd-module-cgi \
	linuxptp \
	lmsensors \
	memtester \
	net-tools \
	nfs-utils-client \
	openssh \
	openssh-sftp-server \
	packagegroup-core-ssh-openssh \
	packagegroup-sdk-target \
	pciutils \
	perl \
	tar \
	tcpdump \
	usbutils \
	vim \
	vim-vimrc \
"

export IMAGE_BASENAME = "extended-console-image"

#	achilles-lighttpd-conf \
#	achilles-linux-firmware \
#	achilles-webcontent \
#	achilles-x11vnc-init \
#	achilles-xfce-default-config \
#	achilles-xfce-init \
