#!/usr/bin/env python
# vim: sw=4 et

import os
import yaml

from re import split
from pathlib import Path

try:
    from rich import print
    from rich.console import Console
    console = Console()
    from rich.traceback import install
    install(show_locals=True)
except:
    print('INFO: Could not load optional python module "rich".')

os.chdir('./home/')
folders = list(Path('.').rglob('.'))
os.chdir('..')

home_path = f'{os.getenv("HOME")}'
default_config_file_path = f'{home_path}/.config/dotfiles/compilenix/config.yml'
config_file_paths = default_config_file_path, f'{home_path}/.config/dotfiles/compilenix/config.yaml'
default_config = dict(
    link_fonts = False,
    link_desktop_software_configs = False,
    enable_hush_login = True,
)
config = dict()


def ask_yn(prompt: str, default: bool):
    default_yn = 'Y/n' if default else 'y/N'
    result = default
    while True:
        answer = input(f'{prompt} [{default_yn}]: ').lower()
        if len(answer) == 0:
            break
        if len(answer) != 1:
            continue
        if answer == 'y':
            result = True
            break
        if answer == 'n':
            result = False
            break
    return result


config_file = None
for file in config_file_paths:
    if os.path.isfile(file):
        config_file = file
        break

if config_file is None:
    existing_path = ''
    path_list = split(r'\/', default_config_file_path)
    path_list.remove('')
    filename = path_list.pop()
    config_file = default_config_file_path

    for element in path_list:
        if element == filename:
            break # we are done here
        existing_path = f'{existing_path}/{element}'
        if os.path.isdir(existing_path):
            continue # path exists, continue traversing path structure
        os.mkdir(existing_path)

if os.path.exists(config_file):
    config = yaml.safe_load(open(config_file))

is_loaded_config_partial = False
if 'link_fonts' not in config:
    config['link_fonts'] = ask_yn('Install fonts?', default_config['link_fonts'])
    is_loaded_config_partial = True
if 'link_desktop_software_configs' not in config:
    is_loaded_config_partial = True
    config['link_desktop_software_configs'] = ask_yn('Install install desktop software configs?', default_config['link_desktop_software_configs'])
if 'enable_hush_login' not in config:
    config['enable_hush_login'] = ask_yn('Disable login banner?', default_config['enable_hush_login'])
    is_loaded_config_partial = True

if is_loaded_config_partial:
    if os.path.isfile(config_file):
        with open(config_file, 'w', 1024, 'utf8') as config_file:
            yaml.safe_dump(config, config_file)
    else:
        with open(config_file, 'x', 1024, 'utf8') as config_file:
            yaml.safe_dump(config, config_file)

print(f'config file location: {str(config_file)}')
print(f'config: {config}')

hushlogin_file = f'{home_path}/.hushlogin'
if config['enable_hush_login'] and not os.path.exists(hushlogin_file):
    print(f'create file "{home_path}/.hushlogin"')
    os.mknod(hushlogin_file)
if not config['enable_hush_login'] and os.path.exists(hushlogin_file):
        os.remove(hushlogin_file)
        print(f'removed \'{hushlogin_file}\'')

for folder in folders:
    if str(folder) == '.':
        destination_path = f'{home_path}'
    else:
        destination_path = f'{home_path}/{folder}'
    if destination_path.startswith(f'{home_path}/.fonts'):
        if config['link_fonts'] == False:
            continue
    if destination_path.startswith(f'{home_path}/.config/clipit') or \
        destination_path.startswith(f'{home_path}/.config/git') or \
        destination_path.startswith(f'{home_path}/.config/i3') or \
        destination_path.startswith(f'{home_path}/.config/sway') or \
        destination_path.startswith(f'{home_path}/.config/volumeicon') or \
        destination_path.startswith(f'{home_path}/.config/waybar'):
        if config['link_desktop_software_configs'] == False:
            continue

    if not os.path.exists(destination_path):
        print(f'create directory "{destination_path}"')
        os.makedirs(destination_path)

    filenames = next(os.walk(f'./home/{folder}'), (None, None, []))[2]
    for filename in filenames:
        if f'{destination_path}/{filename}'.endswith('/.Xresources') or \
            f'{destination_path}/{filename}'.endswith('/.xinitrc') or \
            f'{destination_path}/{filename}'.endswith('/.xinitrc_reset') or \
            f'{destination_path}/{filename}'.endswith('/.config/compton.conf') or \
            f'{destination_path}/{filename}'.endswith('/.config/mimeapps.list') or \
            f'{destination_path}/{filename}'.endswith('/.config/pavucontrol.ini') or \
            f'{destination_path}/{filename}'.endswith('/dotfiles_bin/grimshot') or \
            f'{destination_path}/{filename}'.endswith('/dotfiles_bin/lock.sh') or \
            f'{destination_path}/{filename}'.endswith('/dotfiles_bin/sway') or \
            f'{destination_path}/{filename}'.endswith('/dotfiles_bin/sway-lock.sh') or \
            f'{destination_path}/{filename}'.endswith('/dotfiles_bin/volume.sh') or \
            f'{destination_path}/{filename}'.endswith('/dotfiles_bin/wl-xwayland-get-active-output.sh'):
            if config['link_desktop_software_configs'] == False:
                continue

        # existing file or symlink
        if os.path.exists(f'{destination_path}/{filename}'):
            continue
        # existing symlink but it's broken, remove it
        if os.path.islink(f'{destination_path}/{filename}'):
            os.remove(f'{destination_path}/{filename}')
        if filename == '.tmux.conf_v1' or filename == '.tmux.conf_v2':
            continue
        print(f'create link "{destination_path}/{filename}"')
        link_file = Path(f'{destination_path}/{filename}')
        if str(folder) == '.':
            link_file.symlink_to(f'{os.getcwd()}/home/{filename}')
        else:
            link_file.symlink_to(f'{os.getcwd()}/home/{folder}/{filename}')
