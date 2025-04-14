export REPOSITORY_URL=git.produccion.gob.ar/legajo-unico/lu-aplicacion.git

git pull https://$deploy_token_name:$deploy_token_value@$REPOSITORY
# git pull $CI_REPOSITORY_URL
php artisan config:clear
php artisan cache:clear
php artisan view:clear
