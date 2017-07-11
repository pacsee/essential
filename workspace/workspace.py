import argparse
import getpass
import os
import sys

import yaml

# Add the current dir to sys path
sys.path.append(os.path.dirname(__file__))

import vault


HOME = os.path.join(os.path.expanduser("~"), '.workspaces')
WORKSPACES = [
    f[:-4] for f in os.listdir(HOME) if(
        os.path.isfile(os.path.join(HOME, f)) and
        f.endswith('.yml') and
        not f.startswith('_')
    )
]


def main(args):
    handler = args.Handler(args)
    handler()


class Command(object):

    def __init__(self, args):
        self.args = args

    @classmethod
    def get_parser(cls, subparser, *args, **kwargs):
        parser = subparser.add_parser(*args, **kwargs)
        parser.set_defaults(Handler=cls)
        return parser

class InitCommand(Command):

    def __call__(self):
        print('x')


class LSCommand(Command):

    @classmethod
    def get_parser(cls, subparser, *args, **kwargs):
        parser = super(LSCommand, cls).get_parser(subparser, *args, **kwargs)
        parser.add_argument(
            '--completion', action='store_true',
            help='one line space separated list'
        )
        return parser

    def __call__(self):
        if self.args.completion:
            print(" ".join(WORKSPACES))
            sys.exit(0)
        for ws in WORKSPACES:
            print(ws)

class ActivateCommand(Command):

    def __init__(self, args):
        super(ActivateCommand, self).__init__(args)
        self.context = {}

    @classmethod
    def get_parser(cls, subparser, *args, **kwargs):
        parser = super(ActivateCommand, cls).get_parser(subparser, *args, **kwargs)
        parser.add_argument(
            'workspace', help='name of workspace', choices=WORKSPACES
        )
        return parser

    def __call__(self):
        fn = os.path.join(HOME, self.args.workspace + '.yml')
        stream = self.generate_instructions(fn)
        print("".join(stream))

    def generate_instructions(self, fn):
        stream = []
        instructions = self.get_instructions(fn)
        for instruction in instructions:
            if isinstance(instruction, dict):
                for name, param in instruction.items():
                    command = self.get_instruction(name, stream, param)
                    command.handle()
            else:
                command = self.get_instruction(instruction, stream)
                command.handle()
        return stream

    def get_instructions(self, fn):
        with open(fn) as f:
            return yaml.load(f)

    def get_instruction(self, name, stream, param=None):
        instruction = {
            'workdir': WorkDirGenerator,
            'conda': CondaGenerator,
            'nvm': NvmGenerator,
            'source': SourceGenerator,
            'workon': WorkonGenerator,
            'bash': BashGenerator,
            'docker-machine': DockerMachineGenerator,
            'env': EnvGenerator,
            'path': PathGenerator,
            'pythonpath': PythonPathGenerator,
            'include': IncludeGenerator,
            'getpass': GetPassGenerator,
            'context': ContextGenerator,
            'debug': DebugGenerator,
        }.get(name)
        if not instruction:
            sys.exit("The instruction '%s' doesn't exist" % name)
        return instruction(stream, param, self)


class WrapCommand(Command):

    def __init__(self, args):
        super(WrapCommand, self).__init__(args)
        self.context = {}

    @classmethod
    def get_parser(cls, subparser, *args, **kwargs):
        parser = super(WrapCommand, cls).get_parser(subparser, *args, **kwargs)
        parser.add_argument(
            'workspace', help='name of workspace', choices=WORKSPACES
        )
        return parser

    def __call__(self):
        fn = os.path.join(HOME, self.args.workspace + '.yml')
        stream = self.generate_instructions(fn)
        print("".join(stream))

    def generate_instructions(self, fn):
        stream = []
        instructions = self.get_instructions(fn)
        for instruction in instructions:
            if isinstance(instruction, dict):
                for name, param in instruction.items():
                    command = self.get_instruction(name, stream, param)
                    if command:
                        command.handle()
            else:
                command = self.get_instruction(instruction, stream)
                command.handle()
        return stream

    def get_instructions(self, fn):
        with open(fn) as f:
            return yaml.load(f)

    def get_instruction(self, name, stream, param=None):
        instruction = {
            'conda': CondaPathGenerator,
            'bash': BashGenerator,
            'docker-machine': DockerMachineGenerator,
            'env': EnvGenerator,
            'path': PathGenerator,
            'pythonpath': PythonPathGenerator,
        }.get(name)
        if not instruction:
            return None
        return instruction(stream, param, self)


class Generator(object):
    def __init__(self, stream, param, generator):
        self.stream = stream
        self.param = param
        self.generator = generator
        self.context = self.generator.context

    def handle(self):
        pass

    def writeln(self, string):
        self.stream.append(string.format(**self.context))
        self.stream.append(os.linesep)


class WorkDirGenerator(Generator):

    def handle(self):
        self.writeln('cd %s' % self.param)


class CondaGenerator(Generator):

    def handle(self):
        self.writeln('source activate %s' % self.param)


class NvmGenerator(Generator):

    def handle(self):
        self.writeln('nvm use %s' % self.param)


class CondaPathGenerator(Generator):

    def generate_path_list(self):
        path = '~/anaconda/envs/%s/bin' % self.param
        return os.pathsep.join([path, '$PATH'])

    def handle(self):
        self.writeln('export PATH=%s' % self.generate_path_list())


class SourceGenerator(Generator):

    def handle(self):
        self.writeln('source %s' % self.param)


class WorkonGenerator(Generator):

    def handle(self):
        self.writeln('workon %s' % self.param)


class BashGenerator(Generator):

    def handle(self):
        self.writeln(self.param)


class DockerMachineGenerator(Generator):

    def handle(self):
        self.writeln('eval "$(docker-machine env %s)"' % self.param)
        self.writeln('echo "Docker machine %s attached"' % self.param)


class PathGenerator(Generator):

    def generate_path_list(self, base):
        paths = list(self.param)
        paths.append(base)
        return os.pathsep.join(paths)

    def handle(self):
        self.writeln('export PATH=%s' % self.generate_path_list('$PATH'))


class PythonPathGenerator(PathGenerator):

    def handle(self):
        self.writeln(
            'export PYTHONPATH=%s' % self.generate_path_list('$PYTHONPATH')
        )


class IncludeGenerator(Generator):

    def handle(self):
        s = self.generator.generate_instructions(os.path.join(HOME, self.param))
        self.stream.extend(s)


class EnvGenerator(Generator):

    def handle(self):
        for key, value in self.param.items():
            self.writeln('export %s="%s"' % (key, value))


class GetPassGenerator(Generator):

    def handle(self):
        for key, value in self.param.items():
            self.generator.context[key] = getpass.getpass(value+': ')


class ContextGenerator(Generator):

    def handle(self):
        for key, value in self.param.items():
            self.generator.context[key] = value


class DebugGenerator(Generator):

    def handle(self):
        self.writeln('echo "**** [ DEBUG ] *****************************"')
        for key, value in self.generator.context.items():
            self.writeln('echo "%s: %s"' % (key, value))


def get_args(prog, argv):
    parser = argparse.ArgumentParser(
        description='Generate bash script based on given yml',
        prog='workspace'
    )
    parser.add_argument('--config')
    subparser = parser.add_subparsers(
        help='available commands',
        metavar='command'
    )
    ActivateCommand.get_parser(subparser, 'activate', help='Activate a workspace')
    InitCommand.get_parser(subparser, 'init', help='initialize')
    LSCommand.get_parser(subparser, 'ls', help='list workspaces')
    WrapCommand.get_parser(subparser, 'wrap', help='wrap command')
    return parser.parse_args(argv)


if __name__ == '__main__':
    main(get_args(sys.argv[0], sys.argv[1:]))
