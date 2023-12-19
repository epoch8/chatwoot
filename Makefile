# Variables
VERSION=$(shell cat version)

IMAGE=ghcr.io/epoch8/chatwoot/chatwoot:${VERSION}
BRANCH=$(shell git rev-parse --abbrev-ref HEAD)

APP_NAME := chatwoot
RAILS_ENV ?= development

# Targets
setup:
	gem install bundler
	bundle install
	yarn install

db_create:
	RAILS_ENV=$(RAILS_ENV) bundle exec rails db:create

db_migrate:
	RAILS_ENV=$(RAILS_ENV) bundle exec rails db:migrate

db_seed:
	RAILS_ENV=$(RAILS_ENV) bundle exec rails db:seed

db:
	RAILS_ENV=$(RAILS_ENV) bundle exec rails db:chatwoot_prepare

console:
	RAILS_ENV=$(RAILS_ENV) bundle exec rails console

server:
	RAILS_ENV=$(RAILS_ENV) bundle exec rails server -b 0.0.0.0 -p 3000

burn:
	bundle && yarn

run:
	overmind start -f Procfile.dev

docker:
	docker build -t $(APP_NAME) -f ./docker/Dockerfile .

# e8
build:
	if [ "$(BRANCH)" != "e8" ]; then \
		docker build -t ${IMAGE}-${BRANCH} -f docker/Dockerfile . ; \
	else \
		docker build -t ${IMAGE} -f docker/Dockerfile . ; \
	fi

upload:
	if [ "$(BRANCH)" != "e8" ]; then \
		docker push ${IMAGE}-${BRANCH} ; \
	else \
		docker push ${IMAGE} ; \
	fi

.PHONY: setup db_create db_migrate db_seed db console server burn docker run build upload
