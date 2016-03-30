.PHONY: all build default release serve

default: release

all: build

build:
	docker build --rm --force-rm -t soulshake/blog .

release: build
	docker run --rm -it -v $(CURDIR)/public:/usr/src/blog/public -e AWS_S3_BUCKET -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY soulshake/blog

serve: build
	docker run --rm -it --net host --entrypoint hugo soulshake/blog server


