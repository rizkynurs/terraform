#!/bin/bash
set -e

# Pre-installation script for CentOS 7 on Huawei ECS
sed -i 's|mirrorlist=http://mirrorlist.centos.org|#mirrorlist=http://mirrorlist.centos.org|g' /etc/yum.repos.d/CentOS-*
sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

# Pre-installation script for Huawei ECS setup
echo "Updating package lists..."
yum update -y
yum groupinstall 'Development Tools' -y

# Install necessary packages
echo "Installing required packages..."
yum -y install vim net-tools bind-utils telnet autoconf wget net-snmp yum-utils mariadb-devel python3 python3-devel bzip2-devel postgresql-devel libffi-devel git gcc curl pcre mtr pcre-devel libxml2 htop libxml2-devel curl-devel GeoIP-devel libmaxminddb-devel cmake zlib-devel make openssl-devel davfs2 lua-devel
echo ""

# Set timezone
echo "Configuring timezone..."
timedatectl set-timezone Asia/Jakarta
echo ""
#rm -rf /etc/localtime ; ln -s /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# Install Supervisor and configure
echo "Installing Supervisor..."
yum install epel-release supervisor -y
sed -i '/Type\=forking/a LimitNOFILE\=65535' /usr/lib/systemd/system/supervisord.service
systemctl enable supervisord ; systemctl restart supervisord

# Add www-data user and group if not exists
echo "Adding www-data user and group..."
if id -u "www-data" >/dev/null 2>&1; then
   echo 'user exists'
else
   groupadd www-data -g 500; useradd -g 500 -u 500 www-data
fi
echo ""

# Disable swap (if required)
# echo "Disabling swap..."
# sudo swapoff -a
# sudo sed -i '/ swap / s/^/#/' /etc/fstab

# Configure limits for nproc
echo "Configuring limits for nproc..."
cat > /etc/security/limits.d/90-nproc.conf <<EOF
* soft nproc 65535
* hard nproc 65535
EOF

ulimit -a
echo ""

# Configure Sysctl
echo "Configuring sysctl..."
cat > /etc/sysctl.conf<<EOF

vm.swappiness = 0
net.ipv4.neigh.default.gc_stale_time = 120

net.ipv4.conf.all.rp_filter = 0
net.ipv4.conf.default.rp_filter = 0
net.ipv4.conf.default.arp_announce = 2
net.ipv4.conf.lo.arp_announce = 2
net.ipv4.conf.all.arp_announce = 2

net.ipv4.tcp_max_tw_buckets = 5000
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_max_syn_backlog = 1024
net.ipv4.tcp_synack_retries = 2

net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1

kernel.sysrq = 1
###
#
net.ipv4.tcp_tw_reuse = 1
###
net.core.wmem_max = 8388608
net.core.rmem_max = 8388608
net.ipv4.tcp_rmem = 4096 87380 8388608
net.ipv4.tcp_wmem = 4096 87380 8388608
net.ipv4.tcp_fin_timeout = 5
net.ipv4.tcp_keepalive_time = 1800
net.ipv4.tcp_congestion_control = scalable
net.ipv4.ipfrag_high_thresh = 524288
net.ipv4.ipfrag_low_thresh = 393216
net.ipv4.ip_local_port_range = 1024 65535

net.ipv4.tcp_max_syn_backlog = 65535
net.core.netdev_max_backlog = 65535
net.core.somaxconn =65535
fs.file-max = 2621400

net.ipv4.conf.all.arp_filter = 1
net.ipv4.conf.all.arp_announce = 2
net.ipv4.conf.all.arp_ignore = 1
net.ipv4.conf.all.rp_filter = 0

net.core.somaxconn = 65535
net.ipv4.tcp_max_syn_backlog = 65535
net.core.netdev_max_backlog = 65535
vm.overcommit_memory = 1
vm.max_map_count=262144

fs.inotify.max_user_watches = 262144
EOF
sysctl -p

# Enable IP forwarding
# echo "Enabling IP forwarding..."
# sudo sysctl -w net.ipv4.ip_forward=1
# sudo sysctl -p

sleep 2s
echo ""
echo "Pre-installation setup completed successfully."