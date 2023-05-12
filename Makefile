init: docker-down-clear docker-pull docker-build-pull docker-up
down: docker-down-clear
check: lint analyze test

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

app-init: composer-install

composer-install:
	docker-compose run --rm php-cli composer install --ignore-platform-reqs --no-scripts

composer-update:
	docker-compose run --rm php-cli composer update --ignore-platform-reqs --no-scripts

test:
	docker-compose run --rm php-cli composer test

lint:
	docker-compose run --rm php-cli composer php-cs-fixer fix -- --diff --dry-run

cs-fix:
	docker-compose run --rm php-cli composer php-cs-fixer fix

analyze:
	docker-compose run --rm php-cli composer psalm -- --no-diff
