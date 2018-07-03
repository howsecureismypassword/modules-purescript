.PHONY: all

all: build.js build.min.js

output/%.js:
	pulp build

build.js: output/Calculator/index.js output/Checker/index.js output/Main/index.js output/NamedNumber/index.js output/Period/index.js output/Utility/index.js output/Checks.Dictionary/index.js output/Checks.Pattern/index.js output/Checks.Patterns/index.js
	pulp build --skip-entry-point -t build.js
	echo "module.exports = PS.Main.setup" >> build.js

build.min.js: build.js
	uglifyjs -m -c -- build.js > build.min.js
