#!/usr/bin/bash
# Generate a minimal filesystem for archlinux and load it into the local
# docker as "archlinux"
# requires root
set -e

if [ $# -lt 2 ]
  then
    echo "Usage: $0 <arch> <registry>"
    echo "Example : $0 armv7 myregistry.local.lan"
    echo ""
    exit 0
fi

arch="$1"
registry="$2"
tag=`date +%Y%m%d`

hash pacstrap &>/dev/null || {
	echo "Could not find pacstrap. Run pacman -S arch-install-scripts"
	exit 1
}

hash expect &>/dev/null || {
	echo "Could not find expect. Run pacman -S expect"
	exit 1
}

export LANG="C.UTF-8"

ROOTFS=$(mktemp -d ${TMPDIR:-/var/tmp}/rootfs-archlinux-XXXXXXXXXX)
chmod 755 $ROOTFS

# packages to ignore for space savings
PKGIGNORE=(
    dhcpcd
    iproute2
    jfsutils
    linux
    lvm2
    man-db
    man-pages
    mdadm
    nano
    netctl
    openresolv
    pciutils
    pcmciautils
    reiserfsprogs
    s-nail
    systemd-sysvcompat
    usbutils
    vi
    xfsprogs
)
IFS=','
PKGIGNORE="${PKGIGNORE[*]}"
unset IFS


case "$arch" in
	armv*)
		if pacman -Q archlinuxarm-keyring >/dev/null 2>&1; then
			pacman-key --init
			pacman-key --populate archlinuxarm
		else
			echo "Could not find archlinuxarm-keyring. Please, install it and run pacman-key --populate archlinuxarm"
			exit 1
		fi
		PACMAN_CONF=$(mktemp ${TMPDIR:-/var/tmp}/pacman-conf-archlinux-XXXXXXXXX)
		version="$(echo $arch | cut -c 5)"
		sed "s/Architecture = armv/Architecture = armv${version}h/g" './mkimage-archarm-pacman.conf' > "${PACMAN_CONF}"
		PACMAN_MIRRORLIST='Server = http://de.mirror.archlinuxarm.org/$arch/$repo'
		PACMAN_EXTRA_PKGS='archlinuxarm-keyring'
		EXPECT_TIMEOUT=1800 # Most armv* based devices can be very slow (e.g. RPiv1)
		ARCH_KEYRING=archlinuxarm
		DOCKER_IMAGE_NAME="armv${version}h/archlinux"
		;;
	*)
		PACMAN_CONF='./mkimage-arch-pacman.conf'
		PACMAN_MIRRORLIST='Server = https://mirrors.kernel.org/archlinux/$repo/os/$arch'
		PACMAN_EXTRA_PKGS=''
		EXPECT_TIMEOUT=60
		ARCH_KEYRING=archlinux
		DOCKER_IMAGE_NAME=archlinux
		;;
esac

export PACMAN_MIRRORLIST

expect <<EOF
	set send_slow {1 .1}
	proc send {ignore arg} {
		sleep .1
		exp_send -s -- \$arg
	}
	set timeout $EXPECT_TIMEOUT

	spawn pacstrap -C $PACMAN_CONF -c -d -G -i $ROOTFS base base-devel haveged coreutils bash procps-ng pacman sed gzip tar $PACMAN_EXTRA_PKGS --ignore $PKGIGNORE
	expect {
		-exact "upgrade? \[y/N\] " { send -- "y\r"; exp_continue }
		-exact "anyway? \[Y/n\] " { send -- "n\r"; exp_continue }
		-exact "(default=all): " { send -- "\r"; exp_continue }
		-exact "installation? \[Y/n\]" { send -- "y\r"; exp_continue }
		-exact "delete it? \[Y/n\]" { send -- "y\r"; exp_continue }
	}
EOF

arch-chroot $ROOTFS /usr/bin/sh -c 'rm -r /usr/share/man/*'
arch-chroot $ROOTFS /usr/bin/sh -c "haveged -w 1024; pacman-key --init; pkill haveged; pacman -Rs --noconfirm haveged; pacman-key --populate $ARCH_KEYRING; pkill gpg-agent" || true
arch-chroot $ROOTFS /usr/bin/sh -c "ln -s /usr/share/zoneinfo/UTC /etc/localtime"
echo 'en_US.UTF-8 UTF-8' > $ROOTFS/etc/locale.gen
arch-chroot $ROOTFS locale-gen
arch-chroot $ROOTFS /usr/bin/sh -c 'echo $PACMAN_MIRRORLIST > /etc/pacman.d/mirrorlist'

# udev doesn't work in containers, rebuild /dev
DEV=$ROOTFS/dev
rm -rf $DEV
mkdir -p $DEV
mknod -m 666 $DEV/null c 1 3
mknod -m 666 $DEV/zero c 1 5
mknod -m 666 $DEV/random c 1 8
mknod -m 666 $DEV/urandom c 1 9
mkdir -m 755 $DEV/pts
mkdir -m 1777 $DEV/shm
mknod -m 666 $DEV/tty c 5 0
mknod -m 600 $DEV/console c 5 1
mknod -m 666 $DEV/tty0 c 4 0
mknod -m 666 $DEV/full c 1 7
mknod -m 600 $DEV/initctl p
mknod -m 666 $DEV/ptmx c 5 2
ln -sf /proc/self/fd $DEV/fd

echo "Build images and import..."
tar --numeric-owner --xattrs --acls -C $ROOTFS -c . | docker import - $DOCKER_IMAGE_NAME
echo "Run images for testing..."
docker run --rm -t $DOCKER_IMAGE_NAME echo "Success running in docker !"
echo "Tag with $tag and latest for $registry"
docker tag $DOCKER_IMAGE_NAME $registry/$DOCKER_IMAGE_NAME:$tag
docker tag $DOCKER_IMAGE_NAME $registry/$DOCKER_IMAGE_NAME:latest
echo "push images in registry"
docker push --all-tags $registry/$DOCKER_IMAGE_NAME
echo "remove temp dir..."
rm -Rf $ROOTFS
echo "remove local images..."
docker rmi -f $DOCKER_IMAGE_NAME
docker rmi -f $registry/$DOCKER_IMAGE_NAME:$tag
docker rmi -f $registry/$DOCKER_IMAGE_NAME:latest
