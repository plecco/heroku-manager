#!/bin/bash

app_name='heroku_manager'
mkdir -p "$HOME/.$app_name"
cp -aL "$app_name.sh" "$HOME/.$app_name/$app_name.sh"
echo "source $HOME/.$app_name/$app_name.sh" >> "$HOME/.zshrc"
