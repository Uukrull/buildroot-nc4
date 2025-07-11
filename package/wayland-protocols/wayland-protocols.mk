################################################################################
#
# wayland-protocols
#
################################################################################

WAYLAND_PROTOCOLS_VERSION = 1.11
WAYLAND_PROTOCOLS_SITE = http://wayland.freedesktop.org/releases
WAYLAND_PROTOCOLS_SOURCE = wayland-protocols-$(WAYLAND_PROTOCOLS_VERSION).tar.xz
WAYLAND_PROTOCOLS_LICENSE = MIT
WAYLAND_PROTOCOLS_LICENSE_FILES = COPYING
WAYLAND_PROTOCOLS_INSTALL_STAGING = YES
WAYLAND_PROTOCOLS_INSTALL_TARGET = NO
# needs wayland-scanner
WAYLAND_PROTOCOLS_DEPENDENCIES = host-wayland

$(eval $(autotools-package))
