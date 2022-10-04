#!/bin/bash
# packages = authselect
# platform = Oracle Linux 8,Red Hat Enterprise Linux 8,Red Hat Enterprise Linux 9,multi_platform_fedora
# variables = var_password_pam_unix_remember=5

authselect create-profile hardening -b sssd
CUSTOM_PROFILE="custom/hardening"
authselect select $CUSTOM_PROFILE --force
CUSTOM_SYSTEM_AUTH="/etc/authselect/$CUSTOM_PROFILE/system-auth"
CUSTOM_PASSWORD_AUTH="/etc/authselect/$CUSTOM_PROFILE/password-auth"
for custom_pam_file in $CUSTOM_SYSTEM_AUTH $CUSTOM_PASSWORD_AUTH; do
    if ! $(grep -q "^[^#].*pam_pwhistory\.so.*remember=" $custom_pam_file); then
        sed -i --follow-symlinks "/^password.*requisite.*pam_pwquality\.so/a password    requisite     pam_pwhistory.so use_authtok" $custom_pam_file
    else
        sed -i --follow-symlinks "s/\(.*pam_pwhistory\.so.*\)remember=[[:digit:]]\+\s\(.*\)/\1 \2/g" $custom_pam_file
    fi
done
authselect apply-changes -b
