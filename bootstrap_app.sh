cd /app

# setup application
cp config/database.yml.template config/database.yml
cp config/secrets.yml.template config/secrets.yml
cp .env.template .env

echo installing bundles
bundle install --path ~/.bundles

echo creating and migrating the database
bundle exec rake db:create db:migrate
bundle exec rake db:setup

echo launching the server
bundle exec rails s
echo 'all set, rock on!'
