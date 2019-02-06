#!/bin/bash
#
# App: Heroku Manager
# Description: Built to help developers reduce the time they spend looking up instructions on how to use Heroku CLI tool.
# Author: Jason Stokes
# Email: jpstokes@plecco.net
# Verison: 1.0

function heroku_manager {

  action=$1
  error=

  if [ -z "$action" ]; then
      echo -e "!! Error: No action specified. Please specify an action."
      error=true
  else
      shift
  fi

  if [ -z "$error" ]; then
      while [ "$1" != '' ]; do
          case $1 in
              '-a' | '--app')
                  shift
                  app=$1
                  ;;
              '-d' | '--database')
                  shift
                  database=$1
                  ;;
              '-s' | '--save-file')
                  shift
                  db_file=$1
                  ;;
          esac
          shift
      done
  fi

  if [ "$action" = "help" ] || [ -n "$error" ]; then
      echo -e "\nManages Heroku databases.\n"
      echo -e "Usage:\n"
      echo -e "   heroku_manager <action> <options>\n"
      echo -e "General actions are:\n"
      echo -e "   backup_db                    Capture a backup of database."
      echo -e "   restore_db                   Restore local database with postgres dump."
      echo -e "   retrieve_db                  Download copy of captured database."
      echo -e "   reset_db                     Capture current database, download and restore to local postgres database instance."
      echo -e "   kill_services                Kill ruby and sidekiq instances."
      echo -e "   help                         This help text.\n"
      echo -e "General options are:\n"
      echo -e "   -a, --app                    The app to use."
      echo -e "   -d, --database               The databse to use."
      echo -e "   -s, --save-file              The file to use / save.\n"
  fi

  if [ -z "$error" ]; then
      if [ -z "$db_file" ]; then
          db_file=~/Downloads/latest.dump
      fi

      if [ $action = "kill_services" ]; then
        echo "Killing ruby processes..."
        killall ruby
        # echo "Killing sidekiq processes..."
        # killall sidekiq
      fi

      if [ $action = "restore_db" ]; then
        heroku_manager kill_services
        bundle exec rake db:drop
        bundle exec rake db:create
        pg_restore --verbose --clean --no-owner -h localhost -d $database $db_file
        bundle exec rake db:migrate
      fi

      if [ $action = "backup_db" ]; then
        heroku pg:backups:capture --app $app
      fi

      if [ $action = "retrieve_db" ]; then
        curl -o $db_file `heroku pg:backups public-url --app $app`
        echo "Database can be found at: $db_file"
      fi

      if [ $action = "reset_db" ]; then
        heroku_manager backup_db $app
        heroku_manager retrieve_db $app
        heroku_manager restore_db $db_file
      fi
  fi
}
