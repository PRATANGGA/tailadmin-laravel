#!/bin/bash
set -e

echo "▶️  Menjalankan setup aplikasi Laravel..."

# 1. Install dependencies Laravel dan JS
composer install --no-interaction --prefer-dist --optimize-autoloader
npm install
npm run build

# 2. Setup .env (hanya jika belum ada)
if [ ! -f ".env" ]; then
    cp .env.example .env
fi

# 3. Generate key
php artisan key:generate

# 4. Konfigurasi koneksi database
sed -i 's/DB_HOST=.*/DB_HOST=mysql/' .env
sed -i 's/DB_DATABASE=.*/DB_DATABASE=tailadmin/' .env
sed -i 's/DB_USERNAME=.*/DB_USERNAME=root/' .env
sed -i 's/DB_PASSWORD=.*/DB_PASSWORD=password/' .env

# 5. Clear dan cache config
php artisan config:clear
php artisan cache:clear
php artisan view:clear
php artisan config:cache

# 6. Migrate dan seed database
php artisan migrate --force
php artisan db:seed --force

# 7. Storage symlink
php artisan storage:link

echo "✅ Laravel siap dijalankan di container."

