# Сайт Ростовского IT-сообщества

[![Build Status](https://travis-ci.org/IT61/it61-rails.svg?branch=master)](https://travis-ci.org/IT61/it61-rails)
[![Code Climate](https://codeclimate.com/github/IT61/it61-rails.png)](https://codeclimate.com/github/IT61/it61-rails)

## Getting started

Для начала работы с проектом нужно создать конфигурационые файлы на основе шаблонов:

    cp config/database.yml.template config/database.yml
    cp config/secrets.yml.template config/secrets.yml    

Установить бандлы, создать и мигрировать БД:

    bundle install --path vendor/bundle
    bundle exec rake db:setup

Запустить rails-сервер:

    bundle exec rails s

## Style guides

- [Ruby](https://github.com/bbatsov/ruby-style-guide)
- [Rails](https://github.com/bbatsov/rails-style-guide)
- [Formatting](https://github.com/thoughtbot/guides/tree/master/style#formatting)
- [Naming](https://github.com/thoughtbot/guides/tree/master/style#naming) 
- [Testing](https://github.com/thoughtbot/guides/tree/master/style#testing)
- [CoffeeScript](https://github.com/thoughtbot/guides/tree/master/style#coffeescript)
- [Markdown](http://www.cirosantilli.com/markdown-styleguide)

## Requirements
- Ruby 2
- PostgreSQL 9.x