################################################################################
#
# connman
#
################################################################################

CONNMAN_VERSION = 1.42
CONNMAN_SOURCE = connman-$(CONNMAN_VERSION).tar.xz
CONNMAN_SITE = $(BR2_KERNEL_MIRROR)/linux/network/connman
CONNMAN_DEPENDENCIES = libglib2 dbus
CONNMAN_INSTALL_STAGING = YES
CONNMAN_LICENSE = GPL-2.0
CONNMAN_LICENSE_FILES = COPYING
CONNMAN_CPE_ID_VENDOR = intel

# 0001-gweb-Fix-OOB-write-in-received_data.patch
CONNMAN_IGNORE_CVES += CVE-2022-32292

# 0002-wispr-Add-reference-counter-to-portal-context.patch
# 0003-wispr-Update-portal-context-references.patch
CONNMAN_IGNORE_CVES += CVE-2022-32293

CONNMAN_CONF_OPTS = --with-dbusconfdir=/etc

ifeq ($(BR2_INIT_SYSTEMD),y)
CONNMAN_CONF_OPTS += --with-systemdunitdir=/usr/lib/systemd/system
endif

ifeq ($(BR2_PACKAGE_CONNMAN_BLUETOOTH),y)
CONNMAN_CONF_OPTS += --enable-bluetooth
else
CONNMAN_CONF_OPTS += --disable-bluetooth
endif

ifeq ($(BR2_PACKAGE_CONNMAN_DEBUG),y)
CONNMAN_CONF_OPTS += --enable-debug
else
CONNMAN_CONF_OPTS += --disable-debug
endif

ifeq ($(BR2_PACKAGE_CONNMAN_ETHERNET),y)
CONNMAN_CONF_OPTS += --enable-ethernet
else
CONNMAN_CONF_OPTS += --disable-ethernet
endif

ifeq ($(BR2_PACKAGE_CONNMAN_IPTABLES),y)
CONNMAN_CONF_OPTS += --with-firewall=iptables
CONNMAN_DEPENDENCIES += iptables
else ifeq ($(BR2_PACKAGE_CONNMAN_NFTABLES),y)
CONNMAN_CONF_OPTS += --with-firewall=nftables
CONNMAN_DEPENDENCIES += libmnl nftables
endif

ifeq ($(BR2_PACKAGE_CONNMAN_LOOPBACK),y)
CONNMAN_CONF_OPTS += --enable-loopback
else
CONNMAN_CONF_OPTS += --disable-loopback
endif

ifeq ($(BR2_PACKAGE_CONNMAN_NEARD),y)
CONNMAN_CONF_OPTS += --enable-neard
CONNMAN_DEPENDENCIES += neard
else
CONNMAN_CONF_OPTS += --disable-neard
endif

ifeq ($(BR2_PACKAGE_CONNMAN_OFONO),y)
CONNMAN_CONF_OPTS += --enable-ofono
CONNMAN_DEPENDENCIES += ofono
else
CONNMAN_CONF_OPTS += --disable-ofono
endif

ifeq ($(BR2_PACKAGE_CONNMAN_STATS),y)
CONNMAN_CONF_OPTS += --enable-stats
else
CONNMAN_CONF_OPTS += --disable-stats
endif

ifeq ($(BR2_PACKAGE_CONNMAN_WIFI),y)
CONNMAN_CONF_OPTS += --enable-wifi
else
CONNMAN_CONF_OPTS += --disable-wifi
endif

ifeq ($(BR2_PACKAGE_CONNMAN_WIREGUARD),y)
CONNMAN_CONF_OPTS += --enable-wireguard
CONNMAN_DEPENDENCIES += libmnl
else
CONNMAN_CONF_OPTS += --disable-wireguard
endif

ifeq ($(BR2_PACKAGE_CONNMAN_WISPR),y)
CONNMAN_CONF_OPTS += --enable-wispr
CONNMAN_DEPENDENCIES += gnutls
else
CONNMAN_CONF_OPTS += --disable-wispr
endif

ifeq ($(BR2_PACKAGE_IWD),y)
CONNMAN_CONF_OPTS += --enable-iwd
else
CONNMAN_CONF_OPTS += --disable-iwd
endif

define CONNMAN_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D package/connman/S45connman $(TARGET_DIR)/etc/init.d/S45connman
endef

ifeq ($(BR2_PACKAGE_CONNMAN_CLIENT),y)
CONNMAN_LICENSE += , GPL-2.0+ (client)
CONNMAN_CONF_OPTS += --enable-client
CONNMAN_DEPENDENCIES += readline

define CONNMAN_INSTALL_CM
	$(INSTALL) -m 0755 -D $(@D)/client/connmanctl $(TARGET_DIR)/usr/bin/connmanctl
endef

CONNMAN_POST_INSTALL_TARGET_HOOKS += CONNMAN_INSTALL_CM
else
CONNMAN_CONF_OPTS += --disable-client
endif

ifeq ($(BR2_PACKAGE_LIBEXECINFO),y)
CONNMAN_DEPENDENCIES += libexecinfo
CONNMAN_CONF_ENV += LDFLAGS="$(TARGET_LDFLAGS) -lexecinfo"
endif

$(eval $(autotools-package))
