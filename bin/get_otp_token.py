#!/usr/bin/python
import onetimepass as otp
my_secret = 'MY TOKEN'
my_token = otp.get_totp(my_secret)

print(my_token)