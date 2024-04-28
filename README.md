# IT61

## Requirements

- Ruby 3.1.1
- PostgreSQL 16.2

## Development setup

1. Install gems: `bundle install`
2. **optional:** Install `overcommit` for GIT commit hooks
3. **optional:** Install GIT hooks with `overcommit`: `overcommit --install -f`
4. **optional:** Run `overcommit --sign` to trust the hooks in this repository.
5. Setup database and run migrations: `rails db:setup`
6. Run server: `./bin/rails server`

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

## Environment variables

* `ENABLE_QUERY_TRACE=[1|0]` - enable query tracing for ActiveRecord;
* `RACK_MINI_PROFILER=[1|0]` - enable the mini profiler.

## Guidelines

Use the following guides for getting things done, programming well, and
programming in style.

* [Protocol](http://github.com/thoughtbot/guides/blob/master/protocol)
* [Best Practices](http://github.com/thoughtbot/guides/blob/master/best-practices)
* [Style](http://github.com/thoughtbot/guides/blob/master/style)

## License

[MIT](https://github.com/IT61/it61.info/blob/master/LICENSE)
