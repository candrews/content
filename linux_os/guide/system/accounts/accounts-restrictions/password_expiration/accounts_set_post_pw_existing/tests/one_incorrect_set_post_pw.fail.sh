#!/bin/bash
# variables = var_account_disable_post_pw_expiration=30

INACTIVE_VALUE=30
INCORRECT_VALUE=60
TEST_USER="cac_testuser"

# ensure existing users with a password defined have the correct value defined
users_to_set=($(awk -v var=\"$INACTIVE_VALUE\" -F: '(($7 <= var || $7 == \"\") && $2 ~ /^\$/) {print $1}' /etc/shadow))
for user in ${users_to_set[@]};
do
   chage --inactive $INACTIVE_VALUE $user
done

# create valid testuser entry in /etc/shadow with the incorrect value defined
useradd $TEST_USER
sed -E -i "s/($TEST_USER:)(.*)/\1\$6\$exIFis0tobKRcGBk\$b.UR.Z8h96FdxJ1bgA\/vhdnp0Lsm488swdILNguQX\/5qH5hdmClyYb5xk3TpELXWzr4JOiTlHfRkPsXSjMPjv0:19396:1:60:7:$INCORRECT_VALUE::/" /etc/shadow
