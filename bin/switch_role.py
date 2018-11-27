#!/usr/bin/env python

import socket
import json
import sys
import os
import re
import subprocess
from subprocess import Popen, PIPE
from pprint import pprint


def run_shell(cmd):
    p = Popen(cmd, stdout=PIPE)
    stdout, stderr = p.communicate()
    if p.returncode != 0:
        sys.exit()
    return stdout


def getProcessOutput(cmd):
    process = subprocess.Popen(cmd, stdout=subprocess.PIPE)
    process.wait()
    data, err = process.communicate()
    if process.returncode is 0:
        return data.decode('utf-8')
    else:
        print("Error:", err)
    return ""


usage = "Usage: get-role-token <role> <destination_aws_account_number> <mfa-token>"
role = sys.argv[1] if len(sys.argv) > 1 else sys.exit(usage)
detination_account = sys.argv[2] if len(sys.argv) > 2 else sys.exit(usage)
token = sys.argv[3] if len(sys.argv) > 3 else sys.exit(usage)

#token = str.rstrip(
#    getProcessOutput('get_otp_token.py'))


user = json.loads(
    getProcessOutput(["aws", "iam", "get-user", "--output", "json"]))
match = re.compile("arn\:aws\:iam\:\:(\d+):.*").match(user["User"]["Arn"])
account_number = match.group(1)

response = getProcessOutput([
        "aws", "sts", "assume-role", "--output", "json", "--role-arn",
        "arn:aws:iam::{}:role/{}".format(detination_account, role),
        "--role-session-name", "cli.user-{}".format(user["User"]["UserName"]),
        "--serial-number", "arn:aws:iam::{}:mfa/{}".format(
            account_number,
            user["User"]["UserName"]), "--token-code", "{}".format(token)
    ])
token = json.loads(response)

print("export {}=\"{}\"".format("AWS_ACCESS_KEY_ID",
                                token["Credentials"]["AccessKeyId"]))
print("export {}=\"{}\"".format("AWS_SECRET_ACCESS_KEY",
                                token["Credentials"]["SecretAccessKey"]))
print("export {}=\"{}\"".format("AWS_SESSION_TOKEN",
                                token["Credentials"]["SessionToken"]))
print("export {}=\"{}\"".format("AWS_SECURITY_TOKEN",
                                token["Credentials"]["SessionToken"]))
print("export {}=\"{}\"".format("AWS_ROLE_EXPIRATION",
                                token["Credentials"]["Expiration"]))
print("export {}=\"{}\"".format("AWS_ROLE_NAME", role))