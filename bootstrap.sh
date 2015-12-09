function install {
    echo installing $1
    shift
    apt-get -y install "$@" >/dev/null 2>&1
}

echo updating package information
apt-add-repository -y ppa:brightbox/ruby-ng >/dev/null 2>&1
apt-get -y -qq update

install 'development tools' build-essential curl python-software-properties software-properties-common

install Git git
install PostgreSQL postgresql postgresql-contrib libpq-dev
sudo -u postgres createuser --superuser vagrant
sudo -u postgres createdb -O vagrant activerecord_unittest
sudo -u postgres createdb -O vagrant activerecord_unittest2

install 'Ruby 2.2.3' ruby2.2 ruby2.2-dev
update-alternatives --set ruby /usr/bin/ruby2.2 >/dev/null 2>&1
update-alternatives --set gem /usr/bin/gem2.2 >/dev/null 2>&1

echo installing Bundler
gem install bundler -N >/dev/null 2>&1

install 'ExecJS runtime' nodejs

# Needed for docs generation.
update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8
