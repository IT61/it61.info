# It61
[![CircleCI](https://circleci.com/gh/IT61/it61-rails.svg?style=svg)](https://circleci.com/gh/IT61/it61-rails)

## Development setup

1. Clone repo
2. Install postgresql and create super user in it (matching your OS user name)
3. Install gems

    `bundle update`

4. Install `overcommit` for GIT commit hooks
5. Install GIT hooks with `overcommit`:

    ```
    overcommit --install -f
    ```

6. Run `overcommit --sign` to trust the hooks in this repository.
7. Setup database and run migrations

    ```
    rails db:create db:migrate
    ```
8. Install bower (if not yet) and download js libs

    ```
    npm install -g bower
    bower install
    ```

9. Run server
    `bundle exec rails server`

## Docker development setup

Docker-based development environment requires `docker-compose >= 1.9.0`.  
Visit [https://docs.docker.com/compose/install/](https://docs.docker.com/compose/install/) for more details.  

Use `bin/dev` helper script for docker-compose management. Run `bin/dev` to see some commands to get started.

Run / Stop (daemon mode)
```bash
$ bin/dev up -d
$ bin/dev stop
```

Forwarded ports and access:

* Web: [http://localhost:3000](http://localhost:3000) (host machine).
* Database: `postgres://postgres@localhost:6543` (host machine).

Action | Command
------------ | -------------
Bundler | `bin/dev exec app bundle install`
Setup DB | `bin/dev exec app rails db:create db:migrate`
Console | `bin/dev exec app rails c`

## Guidelines

Use the following guides for getting things done, programming well, and
programming in style.

* [Protocol](http://github.com/thoughtbot/guides/blob/master/protocol)
* [Best Practices](http://github.com/thoughtbot/guides/blob/master/best-practices)
* [Style](http://github.com/thoughtbot/guides/blob/master/style)
