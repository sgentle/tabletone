.PHONY: build watch

build:
	cp tabletone.css fetch.js build
	coffee -co build tabletone.coffee
	cd build && uglifyjs --compress --mangle --screw-ie8 -- tabletone.js > tabletone.min.js
	cd build && uglifyjs --compress --mangle --screw-ie8 -- tabletone.js fetch.js > tabletone.combined.js

watch:
	coffee -cwo example tabletone.coffee

example: build
	cd build && cp fetch.js tabletone.js tabletone.css ../example

