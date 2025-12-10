# Monitor USB activity via command line

udevadm monitor --udev --subsystem-match-usb

# Find the physical location of eth interface

ethtool -p <linkname> <time>
