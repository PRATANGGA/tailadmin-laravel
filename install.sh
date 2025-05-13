#!/bin/bash
set -e

echo "▶️  Menjalankan setup Laravel..."

# 1. Install dependencies Laravel dan JS
composer install
npm install

# 2. Setup .env
cp -n .env.example .env

# 3. Set database
sed -i 's/DB_HOST=127.0.0.1/DB_HOST=mysql/' .env
sed -i 's/DB_DATABASE=.*/DB_DATABASE=tailadmin/' .env
sed -i 's/DB_USERNAME=.*/DB_USERNAME=user/' .env
sed -i 's/DB_PASSWORD=.*/DB_PASSWORD=password/' .env

# 4. Key generate & migrate
php artisan key:generate
php artisan migrate --seed
php artisan storage:link

echo "✅ Laravel siap dijalankan."

