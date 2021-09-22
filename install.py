#!/usr/bin/env python

from rich import print
from rich.console import Console
from rich.repr import Result
console = Console()
from rich.traceback import install
install(show_locals=True)
from pathlib import Path
import os
from pathlib import Path
import yaml

os.chdir('./home/')
folders = list(Path('.').rglob('.'))
os.chdir('..')

config = dict(
    link_fonts = False,
    link_desktop_software_configs = False
)


def ask_yn(prompt: str, default: bool):
    default_yn = "Y/n" if default else "y/N"
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


if not os.path.exists('config.yml'):
    config['link_fonts'] = ask_yn('Install fonts?', config['link_fonts'])
    config['link_desktop_software_configs'] = ask_yn('Install install desktop software configs?', config['link_desktop_software_configs'])
    with open('config.yml', 'x', 1024, 'utf8') as config_file:
        yaml.safe_dump(config, config_file)
config = yaml.safe_load(open("config.yml"))

print(f'config: {config}')

for folder in folders:
    destination_path = f'{os.getenv("HOME")}/{folder}'
    if destination_path.startswith(f'{os.getenv("HOME")}/.fonts'):
        if config['link_fonts'] == False:
            continue
    if destination_path.startswith(f'{os.getenv("HOME")}/.config/clipit') or \
        destination_path.startswith(f'{os.getenv("HOME")}/.config/git') or \
        destination_path.startswith(f'{os.getenv("HOME")}/.config/i3') or \
        destination_path.startswith(f'{os.getenv("HOME")}/.config/sway') or \
        destination_path.startswith(f'{os.getenv("HOME")}/.config/volumeicon') or \
        destination_path.startswith(f'{os.getenv("HOME")}/.config/waybar'):
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
        print(f'create link: "{destination_path}/{filename}"')
        link_file = Path(f'{destination_path}/{filename}')
        link_file.symlink_to(f'{os.getcwd()}/home/{folder}/{filename}')

