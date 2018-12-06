#!/usr/bin/env python

import onetimepass as otp
import os
my_secret = os.environ.get('OTP')
my_token = otp.get_totp(my_secret)

print(my_token)