Report Downloader in Rails (SQL to Excel)
========

Simple Rails 4 based application that allows users to create reports, which are basically stored SQL statements.
The SQL statements are executed by a background worker (Resque)



Installation
========

Step 0.
Make sure a Redis server is installed.

Step 1.
Create a .env file with the following environment variables (or set them directly in your environment)

REPORT_DATABASE_URL=postgres://username:password@ip_of_database:port/database_name  (often the local database)
BIG_DATA_URLL=postgres://username:password@ip_of_database:port/database_name       (the database to download reports from)
SECRET_TOKEN=(128 charachter long random string)

Step 2.
Do a bundle install (bundle install)
Do a database migration  (rake db:migrate)

Step 3.
Run with foreman start / deploy to passenger / push to heroku (WiP)

Step 4.
Create a new user by running in the rails console (rails c)
User.new username: "example.name" , display_name: "Full Example Name", password: "password", hierarchy: 2 (hierarchy 2 for admin, 0 for regular)

Step 5.
Create first report with created admin account.



