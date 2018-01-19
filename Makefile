build:
	docker build -t h3nrik/apacheds .

alp-build:
	docker build -t h3nrik/apacheds:alpine -f Dockerfile.alpine .
