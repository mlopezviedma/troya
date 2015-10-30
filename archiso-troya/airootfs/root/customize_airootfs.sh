#!/bin/bash

set -e -u
locale-gen
ln -svf /usr/share/zoneinfo/America/Buenos_Aires /etc/localtime
cp -aT /etc/skel/ /root/
chmod 700 /root
chmod 750 /etc/sudoers.d
chmod 440 /etc/sudoers.d/g_wheel
sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist
sed -i 's/#\(Storage=\)auto/\1volatile/' /etc/systemd/journald.conf

systemctl enable pacman-init.service choose-mirror.service
systemctl set-default multi-user.target
systemctl enable sshd.socket
systemctl start startup-script.service

ln -sv /mnt/lfs/tools /tools
mkdir -pv /mnt/lfs
echo "Enter password for root user"
while :
do passwd && break
done
groupadd lfs 
useradd -s /bin/bash -g lfs -m -k /dev/null lfs 
cat > /home/lfs/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1="\[\e[G\e[36m\]\u@\h:\[\e[34;1m\]\W\[\e[0m\]\$ " /bin/bash
EOF
cat > /home/lfs/.bashrc << "EOF"
set +h
umask 022
PS1="\[\e[G\e[36m\]\u@\h:\[\e[34;1m\]\W\[\e[0m\]\$ "
LFS=/mnt/lfs
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/tools/bin:/bin:/usr/bin
export PS1 LFS LC_ALL LFS_TGT PATH
alias ls='ls --color=auto --group-directories-first'
alias la='ls -Ah'
alias ll='ls -lh'
EOF
chown lfs:lfs /home/lfs/.bash{_profile,rc}
echo "Enter password for user lfs"
while :
do passwd lfs && break
done
rm /root/.automated_script.sh
cat > /root/.bashrc << "EOF"
export PS1="\[\e[;31;1m\]\u@\h:\[\e[34;1m\]\W\[\e[;0m\]# "
export LFS=/mnt/lfs
alias ls='ls --color=auto --group-directories-first'
alias la='ls -Ah'
alias ll='ls -lh'
if test -z "${XDG_RUNTIME_DIR}"; then
    export XDG_RUNTIME_DIR=/tmp/${UID}-runtime-dir
    if ! test -d "${XDG_RUNTIME_DIR}"; then
        mkdir "${XDG_RUNTIME_DIR}"
        chmod 0700 "${XDG_RUNTIME_DIR}"
    fi
fi
EOF
cat > /root/.bash_profile << "EOF"
export PS1="\[\e[;31;1m\]\u@\h:\[\e[34;1m\]\W\[\e[;0m\]# "
export LFS=/mnt/lfs
alias ls='ls --color=auto --group-directories-first'
alias la='ls -Ah'
alias ll='ls -lh'
if test -z "${XDG_RUNTIME_DIR}"; then
    export XDG_RUNTIME_DIR=/tmp/${UID}-runtime-dir
    if ! test -d "${XDG_RUNTIME_DIR}"; then
        mkdir "${XDG_RUNTIME_DIR}"
        chmod 0700 "${XDG_RUNTIME_DIR}"
    fi
fi
EOF
cp -r /home/lfs/.links/ /root/
mkdir /root/.config
cat > /root/.config/weston.ini << "EOF"
[core]
#modules=xwayland.so
shell=desktop-shell.so
[keyboard]
keymap_layout=es,latam
keymap_options=grp:alt_shift_toggle
[terminal]
font=Liberation Mono
font-size=16
[shell]
num-workspaces=4
EOF
P=
wget http://mil3.duckdns.org/wiki/doku.php/archlinux/upm/upm -O- | iconv -f UTF-8 -t ISO-8859-15 |\
	while read; do
		echo $REPLY | grep '<!-- wikipage stop -->' &>/dev/null && P=
		[ -n "$P" ] && echo $REPLY
		echo $REPLY | grep '<!-- wikipage start -->' &>/dev/null && P=1
	done > /doc/upm_guide.html
