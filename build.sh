#!/bin/bash
script_full_path=$(dirname "$0")
cd $script_full_path || exit 1

rm Packages Packages.zst Packages.xz Packages.bz2 Packages.gz Packages.lzma Packages.lz4 Release

echo "[Repository] Generating Packages..."
apt-ftparchive packages ./pool > Packages
zstd -q -c19 Packages > Packages.zst
xz -c9 Packages > Packages.xz
bzip2 -c9 Packages > Packages.bz2
gzip -nc9 Packages > Packages.gz
lzma -c9 Packages > Packages.lzma
lz4 -c9 Packages > Packages.lz4

echo "[Repository] Generating Release..."
apt-ftparchive \
    -o APT::FTPArchive::Release::Origin="TurBo's Repo" \
    -o APT::FTPArchive::Release::Label="TurBo's Repo" \
    -o APT::FTPArchive::Release::Suite="stable" \
    -o APT::FTPArchive::Release::Version="1.0" \
    -o APT::FTPArchive::Release::Codename="turbo-repo" \
    -o APT::FTPArchive::Release::Architectures="iphoneos-arm" \
    -o APT::FTPArchive::Release::Components="main" \
    -o APT::FTPArchive::Release::Description="This is a self-use software source" \
    release . > Release

echo "[Repository] Finished"
