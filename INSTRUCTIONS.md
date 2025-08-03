# Setup:

Hindsight has relatively few dependencies - it generally just uses Rails, Ruby, and a database. There are plenty of tutorials for installing Ruby on your platform of choice. Currently, the project uses 3.4.1 and PostgreSQL 17, but almost any version of Ruby or PostgreSQL in the past 5 years should work.

Hindsight will likely run using SQLite and MariaDB, as most queries are written using ActiveRecord's ORM. However, SQLite isn't necessarily recommended depending on your use case. Hindsight does not have any understanding of how items get into the database - it is up to you to fill these tables manually, or via other scripts. SQLite generally only lets you have one process writing at a time, so it is tricky to have many scripts constantly waiting
to update their own tables. If you are importing all data manually though, this is a complete non-issue.

You will likely need some kind of graphical tool for editing the database. There is a good chance that your data requires some degree of manual tweaking, and while you can edit things on the command line, crafting individual SQL statements is a lot worse than just clicking a checkbox next to each row. There are many database tools for managing PostgreSQL, but the vast majority of them generally suck for this task. Consider something like Postico if you have a Mac, which is much closer to the UI of something like Microsoft Excel than pgAdmin is.

## 1. Install PostgreSQL

## 2. Install Hindsight's Dependencies

run `bundle install`

If the application was successfully installed (even with no real database), you should be able to run `rails c` and get a shell.

If you get an error about config[:development_hosts] when you open a shell (assuming you're running in development mode), edit:

`config/environments/development.rb`

and add:

`config.hosts += ['hindsight.someurl.com']`


Generate an auth token by typing `SecureRandom.uuid` into the shell, and use that as the auth token in the credentials file.

### Delete the old encrypted credentials file

`rm -rf config/credentials.yml.enc`

### Copy the values from .credentials_sample to your clipboard:

`cat .credentials_sample` (copy the output)

### Open the credentials editor using nano, and paste the previous command's output. Replace any placeholders with actual data.
`EDITOR=nano rails credentials:edit`

### Save and exit.

### Create all the database tables
`rails db:create`
`rails db:schema:load`

### Load a blank filter file
`mv app/helpers/user_filters.sample_rb app/helpers/user_filters.rb`

## 3. Log In

Hindsight has no real mechanism for user management. To log in on a device, you need a cookie set on your machine. The route that sets this cookie is `/auth/<your access token>`. Once logged in, you can browse the site indefinitely, but each device has to authenticate separately.

Edit `app/controllers/application_controller.rb`, removing the `#` from the following line:

`# session[:key] = "hello!"`

Next, access `/auth/<your auth token>`. You should get a smiley face if the token was correct, letting you know you're now signed in. If you want to prevent anyone else from logging in (should your access token leak), comment out the line again in `application_controller.rb`.

## 4. Fill the Cache

Hindsight doesn't use a cache, aside from the overview page (`/` or `/overview/YYYY`), as these pages are too expensive to generate on the fly. A script will figure out how many of each event occurred on each date, and create bubbles reflecting that on the overview page. You can manually run this script by typing `rails runner lib/tasks/date_summary_cache.rb`, but you should automate this using systemd or cron. Depending on the number of items in the database, it generally takes around 5 minutes or so to run. Below is a 
sample systemd script:

hindsight.service:
```
[Unit]
Description=Hindsight
After=network.target

[Service]
WorkingDirectory=/home/<user>/sites/<hindsight dir>
ExecStart=/bin/bash -l -c 'rails runner lib/tasks/date_summary_cache.rb'
Environment=""
StandardOutput=syslog
User=<user>
Group=<user>

[Install]
WantedBy=multi-user.target
```
hindsight.timer:
```
[Unit]
Description=Update Hindsight's Date Summary Cache
Requires=hindsight.service

[Timer]
Unit=hindsight.service
OnCalendar=daily

[Install]
WantedBy=timers.target
```

## 5. Fill the Database

Each database table generally mimics the file format of a dump from that application/service (so for example, the iphone_calls table is almost identical to the table found in an iPhone's Call History SQLite file). Sample scripts exist for importing from various formats, but you may need to modify these to fit your exact use case. All scripts generally take the form of lines to copy/paste into the rails console (via `rails c`). Most of these scripts are for one-and-done imports (generally services that no longer exist). You can automate these tasks on a case-by-case basis if your want. You will likely have to run various commands after importing data, to correct any errors or omissions in your data. Common examples are adding actual names to old call history, filtering out spam messages, or hiding duplicates when there's overlap between services (e.g. Skype and Microsoft Teams have overlapping message history in their dumps).

I suggest keeping track of when you last imported certain data, remembering to update it every so often as you see fit (e.g. all financial records during tax season, etc).

To confirm that data was imported successfully, you should be able to browse to `/date/yyyy-mm-dd` and see those events.
