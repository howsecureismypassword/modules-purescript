.PHONY: all

all: dist/build.js dist/build.min.js

output/%.js:
	pulp build

dist/build.js: output/Calculator/index.js output/Checker/index.js output/Main/index.js output/NamedNumber/index.js output/Period/index.js output/Utility/index.js output/Checks.Dictionary/index.js output/Checks.Pattern/index.js output/Checks.Patterns/index.js
	pulp build --skip-entry-point -t dist/build.js
	echo "\n\nmodule.exports = PS.Main" >> dist/build.js

dist/build.min.js: dist/build.js
	uglifyjs -m -c -- dist/build.js > dist/build.min.js
