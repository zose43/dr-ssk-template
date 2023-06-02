init: docker-down-clear docker-pull docker-build-pull docker-up composer-install
down: docker-down-clear
up: docker-up

ya: search-yandex
gg: search-google

docker-down-clear:
	docker-compose down -v --remove-orphans

docker-pull:
	docker-compose pull

docker-build-pull:
	docker-compose build --pull

docker-up:
	docker-compose up -d

docker-rebuild:
	docker-compose up --build -d

composer-install:
	docker-compose run --rm php-cli composer install --ignore-platform-reqs --no-scripts

composer-update:
	docker-compose run --rm php-cli composer update --ignore-platform-reqs --no-scripts

test:
	docker-compose run --rm php-cli composer test

flush:
	docker-compose exec php-fpm sh -l -c "yii cache/flush-all"

# Parser search commands
search-yandex:
	docker-compose exec php-fpm sh -l -c "yii search/yandex"

search-google:
	docker-compose exec php-fpm sh -l -c "yii search/google"
