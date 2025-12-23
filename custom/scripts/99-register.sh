#!/bin/bash

set -euo pipefail

add_steph() {

	# /home not mounted by default
	mount /home
	useradd -m steph

	# ssh key for geeko2
	mkdir -pm700 /home/steph/.ssh
	echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMgQVm+Mo92kildXKsfIRKNpamsZUDvWmZpgJswwR0mJ snguyen@geeko2' > /home/steph/.ssh/authorized_keys

	chown -R steph:users /home/steph

	cat > /etc/sudoers.d/steph <<- EOF
	steph ALL=(ALL) NOPASSWD:ALL
	EOF
}

profile_config() {
	cat >/root/.profile <<- EOF
	set -o vi
	alias ll='ls -l'
	EOF
}

add_sdb() {
	set -x

	# Find Disk
	# - Assumes driver is sd*
	# - Takes the first disk which size is > 110 GiB
	for disk in /dev/sd*
	do
		DISK=$(fdisk -l $disk | awk ' /^Disk \/dev\// && $3 > 110 { print $2 } ' | sed 's/://')
		[[ -n "${DISK}" ]] && break
	done

	# Now, format and extract UUID
	UUID=$(mkfs.ext4 ${DISK} 2>/dev/null | awk '/UUID/ { print $3 }')

	mount /var
	mkdir -p /var/lib/longhorn
	echo "UUID=${UUID} /var/lib/longhorn ext4 defaults 0 0" >> /etc/fstab
}

register() {
	# Custom CA cert imported as part of the kiwi build
	SUSEConnect --url https://geeko2.suse.lab
}

### MAIN ###

exec > >(exec tee -a /dev/tty0) 2>&1

add_steph
profile_config
register
