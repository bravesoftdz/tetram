@echo off
rmdir /s /q web\bundles
rmdir /s /q app\cache
php app/console cache:clear --env=prod --no-warmup
php app/console cache:clear --env=dev --no-warmup
php app/console assets:install web
php app/console assetic:dump
