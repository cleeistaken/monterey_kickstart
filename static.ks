#
# Sample scripted installation file
#
# Accept the VMware End UserLicense Agreement
vmaccepteula

# Set the root password for the DCUI and Tech Support Mode
rootpw P@ssword123!

# Remove ALL partitions
clearpart --overwritevmfs --alldrives

# The install to the Dell BOSS card.  local disk, DPU in slot 2, and overwrite vmfs
# install --ignoressd --firstdisk --overwritevmfs --dpuPciSlots=<PCIeSlorID>
install --ignoressd --firstdisk="DELLBOSS VD" --overwritevmfs --dpupcislots=2

# Set the static network settings on a specic on a specific network adapter
network --bootproto=static --ip=10.0.0.1 --gateway=10.0.0.254 --netmask=255.255.255.0 --nameserver="8.8.8.8,8.8.4.4" --hostname=esx1.vmware.com --vlanid=1001 --device=e4:3d:1a:03:b2:b0

# Reboot host after installation
reboot

# A sample post-install script
%post --interpreter=python --ignorefailure=true
import time
stampFile = open('/finished.stamp', mode='w')
stampFile.write( time.asctime() )

# A sample firstboot script
# Enable ssh in first boot
%firstboot --interpreter=busybox

# enable & start remote ESXi Shell  (SSH)
vim-cmd hostsvc/enable_ssh
vim-cmd hostsvc/start_ssh

# enable & start ESXi Shell (TSM)
vim-cmd hostsvc/enable_esx_shell
vim-cmd hostsvc/start_esx_shell

# Suppress Shell warning
esxcli system settings advanced set -o /UserVars/SuppressShellWarning -i 1

# NTP
esxcli system ntp set -s time.nist.gov
esxcli system ntp set -e 1

# Enable ESXio SSH
vim-cmd combinersvc/dpu_services/set_policy TSM-SSH on vmdpu0
vim-cmd combinersvc/dpu_services/start TSM-SSH vmdpu0

# End
