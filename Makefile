BIN = ./node_modules/.bin
SRC = src
TEST = tests
BUILD = build
CSS = styles
HTML = src/index.html

build: build-directory html js css test

test: format
	$(BIN)/elm-test --yes --compiler $(shell pwd)/$(BIN)/elm-make

format:
	$(BIN)/elm-format --yes $(SRC) $(TEST)

build-directory:
	mkdir -p $(BUILD)

html:
	cp $(HTML) $(BUILD)/index.html

js:
	$(BIN)/elm-make --yes $(SRC)/App.elm --output $(BUILD)/elm.js
	cp $(SRC)/native.js $(BUILD)/native.js

css:
	cp $(CSS)/*.css $(BUILD)
