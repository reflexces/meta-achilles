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
	i2c-tools \
	iperf3 \
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
	lshw \
	memtester \
	mmc-utils \
	net-tools \
	nfs-utils-client \
	openssh \
	openssh-sftp-server \
	packagegroup-core-ssh-openssh \
	packagegroup-sdk-target \
	perl \
	stress \
	tar \
	tcpdump \
	usbutils \
	vim \
	vim-vimrc \
"

# Define a function that modifies the systemd unit config files with the autologin arguments
# NOTE: Can be replaced by IMAGE_FEATURES += " serial-autologin-root" with Yocto 4.1 and greater
local_autologin () {
    sed -i -e 's/^\(ExecStart *=.*getty \)/\1-a root /' ${IMAGE_ROOTFS}${systemd_system_unitdir}/serial-getty@.service
}

# Add the function so that it is executed after the rootfs has been generated
ROOTFS_POSTPROCESS_COMMAND += "local_autologin; "

export IMAGE_BASENAME = "extended-console-image"

#	achilles-lighttpd-conf \
#	achilles-linux-firmware \
#	achilles-webcontent \
#	achilles-x11vnc-init \
#	achilles-xfce-default-config \
#	achilles-xfce-init \
