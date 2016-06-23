# It61

## Development setup

1. Clone repo
2. Install postgresql and create super user in it
3. Install gems
    $ bundle update
4. Configure your database.yml file with your username and password
5. Setup database and run migrations
    % rake db:setup
    % rake db:migrate
6. Run server
    % rails s

## Guidelines

Use the following guides for getting things done, programming well, and
programming in style.

* [Protocol](http://github.com/thoughtbot/guides/blob/master/protocol)
* [Best Practices](http://github.com/thoughtbot/guides/blob/master/best-practices)
* [Style](http://github.com/thoughtbot/guides/blob/master/style)
