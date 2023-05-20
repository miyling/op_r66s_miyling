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

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate

# 师夷长技以制夷
git clone https://github.com/xiaorouji/openwrt-passwall -b packages package/passwall_packages
git clone https://github.com/xiaorouji/openwrt-passwall -b luci-smartdns-new-version package/luci-app-passwall

# ddns-go
# git clone https://github.com/sirpdboy/luci-app-ddns-go package/luci-app-ddns-go

# lucky
git clone https://github.com/sirpdboy/luci-app-lucky package/lucky

# smartdns
git clone https://github.com/pymumu/luci-app-smartdns -b lede package/luci-app-smartdns

# ad home
git clone https://github.com/rufengsuixing/luci-app-adguardhome package/luci-app-adguardhome

# watchcat-plus
rm -rf feeds/packages/utils/watchcat
svn co https://github.com/openwrt/packages/trunk/utils/watchcat feeds/packages/utils/watchcat
git clone https://github.com/gngpp/luci-app-watchcat-plus package/luci-app-watchcat-plus

# 晶晨宝盒
git clone https://github.com/ophub/luci-app-amlogic package/luci-app-amlogic

# feeds up
./scripts/feeds update -a
./scripts/feeds install -a
