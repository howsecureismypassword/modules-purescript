.PHONY: all

all: dist/build.js dist/build.min.js
	node dist/test.js

Makefile.test: $(shell find src -type f) $(shell find test -type f)
	touch Makefile.test
	spago test

dist/build.js: $(shell find src -type f)
	spago bundle-module --to dist/build.js
	echo "\n\nmodule.exports = PS.Main.setup" >> dist/build.js

dist/build.min.js: dist/build.js
	uglifyjs -m -c -- dist/build.js > dist/build.min.js
