# Input $1: dev or prod
# Input $2: the git tag to release
cd ~/workspace/public/
rm -R var/cache
rm -R var/sessions
rm var/bootstrap.php.cache
git reset --hard HEAD
git pull
git checkout tags/$2 -b v$2
mysql-ctl start
composer update
bower update
php bin/console cache:clear --env=$1
php bin/console doctrine:schema:update --dump-sql
php bin/console doctrine:schema:update --force
php bin/console lexik:translations:import AppBundle --cache-clear
php bin/console assets:install --env=$1 --symlink
php bin/console assetic:dump --env=$1 --no-debug
php bin/console cache:warmup --env=$1