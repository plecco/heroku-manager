# heroku-manager

Bash script to reduce the complexity of using the Heroku CLI by making routine tasks much simpler.

## Install

Depends on Heroku CLI already being installed.

After installing Heroku CLI clone this repo.

`git clone git@github.com:jpstokes/heroku-manager.git`

Then cd into folder and run `sh install.sh`

This will install the script in `.heroku_manager` in your home directory and source the necessary file in your `.zshrc` file.

If using bash you'll need to add the following line to your .bashrc file:

`source $HOME/.heroku_manager/heroku_manager.sh`

### Example

To perform backup of example db on app example and save to downloads then use download to restore local db

`heroku_manager reset_db -d example -s ~/Downloads/example-backup.sql -a example`

For more help, do the following:

`heroku_manager help`
