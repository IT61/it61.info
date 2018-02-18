# It61
[![CircleCI](https://circleci.com/gh/IT61/it61-rails.svg?style=svg)](https://circleci.com/gh/IT61/it61-rails)

## Requirements

- Ruby 2.4.1 (with bundler)
- PostgreSQL >= 9.5
- Redis

## Development setup

1. Install gems

    `bundle install`

2. **optional** Install `overcommit` for GIT commit hooks
3. **optional** Install GIT hooks with `overcommit`:

    ```
    overcommit --install -f
    ```

4. **optional** Run `overcommit --sign` to trust the hooks in this repository.
5. Before creating the database you must setup connection strings for PostgreSQL and Redis. Put these default values to `.env` file:

    ```
    DATABASE_URL=postgres://postgres@localhost:5432/it61
    REDIS_URL=redis://localhost:6379
    ```

6. Setup database and run migrations

    ```
    rails db:setup
    ```

7. Run server
    `./bin/rails server`

## Docker development setup

Docker-based development environment requires `docker-compose >= 1.9.0`.  
Visit [https://docs.docker.com/compose/install/](https://docs.docker.com/compose/install/) for more details.

Forwarded ports and access:

* Web: [http://localhost:3000](http://localhost:3000) (host machine).
* Database: `postgres://postgres@localhost:6543` (host machine).

Use `bin/dev` helper script for `docker-compose` management. Run `bin/dev -h` to see help for this tool.

First time you will need to build containers, get gems installed and manually migrate database.

```bash
$ bin/dev up -d
$ bin/dev log
### wait until gems installed
$ bin/dev migrate
### develop
$ bin/dev stop
```

After first run when all gems installed and migration applied you can just use simple `bin/dev start`
and `bin/dev stop` commands to start and stop dev environment.

## Guidelines

Use the following guides for getting things done, programming well, and
programming in style.

* [Protocol](http://github.com/thoughtbot/guides/blob/master/protocol)
* [Best Practices](http://github.com/thoughtbot/guides/blob/master/best-practices)
* [Style](http://github.com/thoughtbot/guides/blob/master/style)

## License

[MIT](https://github.com/IT61/it61-rails/blob/master/LICENSE)