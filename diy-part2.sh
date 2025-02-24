#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

function merge_package(){
    # 参数1是分支名,参数2是库地址。所有文件下载到指定路径。
    # 同一个仓库下载多个文件夹直接在后面跟文件名或路径，空格分开。
    trap 'rm -rf "$tmpdir"' EXIT
    branch="$1" curl="$2" target_dir="$3" && shift 3
    rootdir="$PWD"
    localdir="$target_dir"
    [ -d "$localdir" ] || mkdir -p "$localdir"
    tmpdir="$(mktemp -d)" || exit 1
    git clone -b "$branch" --depth 1 --filter=blob:none --sparse "$curl" "$tmpdir"
    cd "$tmpdir"
    git sparse-checkout init --cone
    git sparse-checkout set "$@"
    for folder in "$@"; do
        mv -f "$folder" "$rootdir/$localdir"
    done
    cd "$rootdir"
}

# Modify default IP
sed -i 's/192.168.1.1/10.1.30.254/g' package/base-files/files/bin/config_generate

# 师夷长技以制夷
git clone https://github.com/xiaorouji/openwrt-passwall-packages package/passwall_packages
git clone https://github.com/xiaorouji/openwrt-passwall2 package/luci-app-passwall2

# ddns-go
# git clone https://github.com/sirpdboy/luci-app-ddns-go package/luci-app-ddns-go

# lucky
git clone  https://github.com/gdy666/luci-app-lucky.git package/lucky

# smartdns
git clone https://github.com/pymumu/luci-app-smartdns package/luci-app-smartdns

# ad home
git clone https://github.com/rufengsuixing/luci-app-adguardhome package/luci-app-adguardhome

# watchcat-plus
rm -rf feeds/packages/utils/watchcat
merge_package master https://github.com/openwrt/packages feeds/packages/utils utils/watchcat
git clone https://github.com/gngpp/luci-app-watchcat-plus package/luci-app-watchcat-plus

# openclash
git clone https://github.com/vernesong/OpenClash package/luci-app-openclash

# 晶晨宝盒
git clone https://github.com/ophub/luci-app-amlogic package/luci-app-amlogic

# argon theme
rm -rf feeds/luci/themes/luci-theme-argon
git clone https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon
git clone https://github.com/jerrykuku/luci-app-argon-config.git luci-app-argon-config

# mosdns
git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns
git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata

# feeds up
./scripts/feeds update -a
./scripts/feeds install -a

# fix xfsprogs error
sed -i 's/-DHAVE_MAP_SYNC/-DHAVE_MAP_SYNC -D_LARGEFILE64_SOURCE/g' feeds/packages/utils/xfsprogs/Makefile
