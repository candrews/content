# platform = multi_platform_all

mkdir -p /etc/ssh/sshd_config.d
touch /etc/ssh/sshd_config.d/nothing
sed -i '/RekeyLimit/d' /etc/ssh/sshd_config /etc/ssh/sshd_config.d/*
