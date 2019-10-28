include $(TOPDIR)/rules.mk

PKG_NAME:=vlmcsd
PKG_VERSION=svn1112
PKG_RELEASE:=2

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/Wind4/vlmcsd.git
PKG_SOURCE_VERSION:=ce1dfa16b26a64dfe58d8e8154ce862cafe396d7
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.xz
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)

PKG_MAINTAINER:=Richard Yu <yurichard3839@gmail.com>

PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk

define Package/vlmcsd
  SECTION:=net
  CATEGORY:=Network
  TITLE:=vlmcsd for OpenWRT
  URL:=http://forums.mydigitallife.info/threads/50234
  DEPENDS:=+libpthread
endef

define Package/vlmcsd/description
	vlmcsd is a KMS Emulator in C.
endef

define Package/vlmcsd/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bin/vlmcsd $(1)/usr/bin/vlmcsd
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bin/vlmcs $(1)/usr/bin/vlmcs

	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/etc/vlmcsd.ini $(1)/etc/vlmcsd.ini

	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/vlmcsd.init $(1)/etc/init.d/vlmcsd

	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) ./files/vlmcsd.defaults $(1)/etc/uci-defaults
endef

define Package/vlmcsd/prerm
#!/bin/sh
s=dhcp.vlmcsd
uci -q get "$$s" >/dev/null || exit 0
uci -q batch <<-EOF >/dev/null
	delete $$s
	commit dhcp
EOF
endef

$(eval $(call BuildPackage,vlmcsd))
