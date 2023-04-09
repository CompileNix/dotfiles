#!python3

import os
import re
import subprocess
import sys
import urllib.parse

# helper functions
home_dir = os.environ['HOME']
subprocess_call_echo_prefix = '\033[0;92m➜\033[0m'
def print_with_prefix(string):
    print(f'{subprocess_call_echo_prefix} {string}')

# check arg length, else print help
if len(sys.argv) < 2 or (len(sys.argv) == 2 and re.match(r'^\-*h(elp)?', sys.argv[1])):
    print(re.sub(r'^ +', '', f"""\
    Do a git clone into `~/code/nginx/njs`.
    Additional args after the url are passed to the git clone command.

    Requirements:
    - git

    Example Usage: {sys.argv[0]} https://github.com/nginx/njs.git --recursive
    """, flags=re.MULTILINE)[:-1], file=sys.stderr)
    sys.exit(1)

# parse first arg as repo url
try:
    repo_url = sys.argv[1]
    repo_url_parsed = urllib.parse.urlparse(repo_url)
except Exception as e:
    print(f'Error parsing the given url "{repo_url}": {e}', file=sys.stderr)
    sys.exit(1)

# validate parsed repo_url_parsed
has_error = False
if repo_url_parsed.scheme == None or repo_url_parsed.scheme == '':
    has_error = True
    print(f'Error: Given url has no network protocol scheme', file=sys.stderr)
if repo_url_parsed.netloc == None or repo_url_parsed.netloc == '':
    has_error = True
    print(f'Error: Given url has no valid hostname', file=sys.stderr)
if repo_url_parsed.path == None or repo_url_parsed.path == '':
    has_error = True
    print(f'Error: Given url has no valid path', file=sys.stderr)
if has_error:
    sys.exit(1)

# remove ".git" from directory name
# /nginx/njs
repo_dir_name = repo_url_parsed.path.replace('.git', '')

# get additional args we want to pass into `git` call
additional_git_command_args = sys.argv[2:]

# validate additional git args and convert the string array into a space separated string
if additional_git_command_args != None and len(additional_git_command_args) > 0:
    additional_git_command_args = ' '.join(map(str, additional_git_command_args))
else:
    additional_git_command_args = None

# base path
# $HOME/code/github.com
base_path = f'{home_dir}/code/{repo_url_parsed.netloc}'

# ['nginx', 'njs']
repo_dir_parts = ' '.join(repo_dir_name.split('/')).split()

# nginx_njs
repo_dir_target_name = '_'.join(repo_dir_parts)

# $HOME/code/github.com/nginx_njs
repo_dir_path = f'{base_path}/{repo_dir_target_name}'

# create destination path, excluding the final repo dir, if it does not exist
if not os.path.isdir(base_path):
    print_with_prefix(f'mkdir -p {base_path}')
    try:
        os.makedirs(base_path, exist_ok=True)
        pass
    except Exception as e:
        print(f'Error creating the target dir "{repo_url}": {e}', file=sys.stderr)
        sys.exit(1)

# create git `command` string
if additional_git_command_args != None:
    command = f'git clone {additional_git_command_args} {repo_url} {repo_dir_path}'
else:
    command = f'git clone {repo_url} {repo_dir_path}'

# run git command
print_with_prefix(command)
subprocess.call(command.split(' '))

