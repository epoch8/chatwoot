VERSION=$(shell cat version)

IMAGE=ghcr.io/epoch8/chatwoot/chatwoot:${VERSION}

build:
	docker build -t ${IMAGE} -f docker/Dockerfile .

upload:
	docker push ${IMAGE}
