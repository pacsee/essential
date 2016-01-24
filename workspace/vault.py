import argparse
import base64
import os
import sys

from Crypto.PublicKey import RSA
import gnupg
import yaml


def main(args):
    handler = args.Handler(args)
    handler()


def get_args(prog, argv):
    parser = argparse.ArgumentParser(
        description='Secret vault handling',
        prog='vault'
    )
    subparser = parser.add_subparsers(
        help='available commands',
        metavar='command'
    )
    CreateCommand.get_parser(subparser, 'create', help='Create a vault')
    GetCommand.get_parser(subparser, 'get', help='Read a vault')
    return parser.parse_args(argv)


class Command(object):

    def __init__(self, args):
        self.args = args

    @classmethod
    def get_parser(cls, subparser, *args, **kwargs):
        parser = subparser.add_parser(*args, **kwargs)
        parser.set_defaults(Handler=cls)
        return parser


class CreateCommand(Command):

    @classmethod
    def get_parser(cls, subparser, *args, **kwargs):
        parser = super(CreateCommand, cls).get_parser(subparser, *args, **kwargs)
        parser.add_argument(
            '-k', '--key',
            dest='key_id',
            help='Owner GnuPG key id', required=True
        )
        parser.add_argument('vault', help='Vault file')
        return parser

    def __call__(self):
        keyring = KeyRing()
        owner = keyring.get_user(self.args.key_id)
        vault = Vault.create(owner)
        vault.update('test', 'value')
        reg = VaultRegistry()
        reg.store(vault, self.args.vault)


class GetCommand(Command):

    @classmethod
    def get_parser(cls, subparser, *args, **kwargs):
        parser = super(GetCommand, cls).get_parser(subparser, *args, **kwargs)
        parser.add_argument(
            '-k', '--key',
            dest='key_id',
            help='Owner GnuPG key id', required=True
        )
        parser.add_argument('vault', help='Vault file')
        return parser

    def __call__(self):
        keyring = KeyRing()
        user = keyring.get_user(self.args.key_id)
        reg = VaultRegistry()
        vault = reg.load(self.args.vault, user)
        print vault.values()


class VaultRegistry(object):


    def store(self, vault, filename):
        with open(filename, 'w') as f:
            f.write(yaml.dump(dict(vault)))

    def load(self, filename, user):
        with open(filename, 'rb') as f:
            return Vault.load(user, yaml.load(f))


class Vault(dict):

    def __init__(self):
        super(Vault, self).__init__(
            keys={},
            data={}
        )

    @classmethod
    def create(cls, owner):
        vault = cls()
        vault.key = RSA.generate(4096)
        vault.add_user(owner, True)
        return vault

    @classmethod
    def load(cls, user, data):
        vault = cls()
        vault['data'] = data['data']
        vault['keys'] = data['keys']
        key_str = user.decrypt(base64.b64decode(vault['keys'][user.user_id]))
        vault.key = RSA.importKey(key_str.data)
        return vault

    def add_user(self, user, private=False):
        if private:
            key = self.key.exportKey('DER')
        else:
            key = self.key.publickey().exportKey('DER')

        self['keys'][user.user_id] = base64.b64encode(user.encrypt(key))

    def update(self, key, value):
        self['data'][key] = base64.b64encode(self.key.publickey().encrypt(value, None)[0])

    def values(self):
        decrypted = {}
        for key, value in self['data'].items():
            decrypted[key] = self.key.decrypt(base64.b64decode(value))
        return decrypted



class KeyRing(object):

    def __init__(self, keyring=None):
        if not keyring:
            keyring = os.path.join(os.path.expanduser("~"), '.gnupg')
        self.gpg = gnupg.GPG(homedir=keyring)

    def get_user(self, user_id):
        return User(self, user_id)


class User(object):

    def __init__(self, key_ring, user_id):
        self.key_ring = key_ring
        self.user_id = user_id

    def encrypt(self, data):
        return self.key_ring.gpg.encrypt(data, self.user_id, armor=False).data

    def decrypt(self, data):
        return self.key_ring.gpg.decrypt(data)



if __name__ == '__main__':
    main(get_args(sys.argv[0], sys.argv[1:]))

