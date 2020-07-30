#require recipes-images/angstrom/core-image-minimal.bb
require recipes-core/images/core-image-minimal.bb

DEPENDS += "bash perl gcc i2c-tools \
"

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
	lighttpd \
	lighttpd-module-cgi \
	linuxptp \
	net-tools \
	nfs-utils-client \
	openssh \
	openssh-sftp-server \
	packagegroup-core-ssh-openssh \
	packagegroup-sdk-target \
	pciutils \
	perl \
	python \
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
