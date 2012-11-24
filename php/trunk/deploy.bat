@echo off
rmdir /s /q web\bundles
php app/console assets:install web
php app/console assetic:dump
php app/console cache:clear --env=prod --no-warmup
