.PHONY: all

all: dist/build.js dist/build.min.js
	node dist/test.js

dist/build.js: $(shell find src -type f)
	spago bundle-module --to dist/build.js
	echo "\n\nmodule.exports = PS.Main.setup" >> dist/build.js

dist/build.min.js: dist/build.js
	uglifyjs -m -c -- dist/build.js > dist/build.min.js
