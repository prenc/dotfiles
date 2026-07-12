#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

install -m 0755 "$SCRIPT_DIR/display-smart-apply" /usr/local/bin/display-smart-apply
install -m 0755 "$SCRIPT_DIR/display-smart-hotplug" /usr/local/bin/display-smart-hotplug
install -m 0755 "$SCRIPT_DIR/display-smart-resume" /usr/lib/systemd/system-sleep/display-smart-resume
rm -f /usr/local/bin/autorandr-smart-apply
rm -f /usr/lib/systemd/system-sleep/autorandr-smart-resume
install -m 0644 "$SCRIPT_DIR/display-smart-hotplug.service" /etc/systemd/system/display-smart-hotplug.service
install -m 0644 "$SCRIPT_DIR/display-smart-lid-listener.service" /etc/systemd/system/display-smart-lid-listener.service
install -m 0644 "$SCRIPT_DIR/90-display-smart-hotplug.rules" /etc/udev/rules.d/90-display-smart-hotplug.rules
install -m 0644 "$SCRIPT_DIR/40-monitor-hotplug-disable.rules" /etc/udev/rules.d/40-monitor-hotplug.rules
rm -rf /etc/systemd/system/autorandr.service.d
rm -rf /etc/systemd/system/autorandr-lid-listener.service.d

systemctl daemon-reload
udevadm control --reload-rules
systemctl disable --now autorandr.service autorandr-lid-listener.service || true
systemctl enable display-smart-lid-listener.service
systemctl restart display-smart-lid-listener.service
systemctl reset-failed autorandr.service autorandr-lid-listener.service || true
systemctl status display-smart-lid-listener.service --no-pager
systemctl status display-smart-hotplug.service --no-pager || true
