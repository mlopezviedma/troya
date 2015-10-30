#!/bin/bash
# Script para descargar las fuentes y la documentación de LFS 7.7-systemd

wget="wget --continue"

lfs_url=http://www.linuxfromscratch.org/lfs/downloads/7.7-systemd
packages_url=ftp://ftp.lfs-matrix.net/pub/lfs/lfs-packages/7.7-systemd

lfs_html=LFS-BOOK-7.7-systemd-NOCHUNKS.html
lfs_pdf=LFS-BOOK-7.7-systemd.pdf
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
