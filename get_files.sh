#!/bin/bash
# Script para descargar las fuentes y la documentación de
# una determinada versión de Linux From Scratch.
# Mariano López Minnucci <mlopezviedma@gmail.com> 31/10/2015

[ -z "$1" ] && lfs_version=7.7-systemd || lfs_version=$1
wget="wget --continue"
lfs_url=http://www.linuxfromscratch.org/lfs/downloads/$lfs_version
packages_url=ftp://ftp.lfs-matrix.net/pub/lfs/lfs-packages/$lfs_version
lfs_html=LFS-BOOK-${lfs_version}-NOCHUNKS.html
lfs_pdf=LFS-BOOK-${lfs_version}.pdf
md5sums_file=md5sums
archiso_dir=archiso-troya
sources_dir=sources
doc_dir=doc
old_wd=$(pwd)

mkdir -p $archiso_dir/$doc_dir
cd $archiso_dir/$doc_dir
$wget $lfs_url/$lfs_html
$wget $lfs_url/$lfs_pdf

cd $old_wd

cd $archiso_dir/$sources_dir
$wget $lfs_url/$md5sums_file
cat $md5sums_file | while read line; do
	echo "$line" | md5sum -c &>/dev/null || \
		$wget $packages_url/$(echo $line | cut -d " " -f 2)
done
rm $md5sums_file

cd $old_wd

