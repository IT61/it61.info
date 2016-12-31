# Сайт Ростовского IT-сообщества

[![Build Status](https://travis-ci.org/IT61/it61-rails.svg?branch=master)](https://travis-ci.org/IT61/it61-rails)
[![Code Climate](https://codeclimate.com/github/IT61/it61-rails.png)](https://codeclimate.com/github/IT61/it61-rails)

## Backlog
- [Полное описание ближайших майлстоунов и задач] (https://docs.google.com/document/d/1yyd4tYYlTWfpnx9rVQVFqnchoyhKrTVGLho9C2h1cGU/)

## Contribution guidelines

Все задачи следует выполнять в формате Pull Request'ов.  
Каждая ветка должна называться `<id задачи>_<название ветки>`.  
Малозначительные либо все коммиты в ветке перед вливанием в master должны быть объединены через squash.  
Сообщение коммита должно содержать внятное пояснение, начинаться с `#<id задачи>`   
и содержать не более 72 символов на каждой строке. Между первой и последующими строками – пустая строка.  
Каждый PR должен быть "зеленым" после выполнения тестов в TravisCI.

## Getting started

Для начала работы с проектом нужно создать конфигурационые файлы на основе шаблонов:

    cp config/database.yml.template config/database.yml
    cp config/secrets.yml.template config/secrets.yml
    cp .env.template .env

Установить бандлы, создать и мигрировать БД:

    bundle install --path vendor/bundle
    bundle exec rake db:setup
    
*В окружении должна быть установлена утилита командной строки ImageMagick или GraphicsMagick.*

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
- [«How to Write a Git Commit Message»](http://chris.beams.io/posts/git-commit/)

## Requirements
- Ruby 2
- PostgreSQL 9.x
- ImageMagick/GraphicsMagick
