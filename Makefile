BIN = ./node_modules/.bin
SRC = src
TEST = tests
BUILD = build
CSS = styles
HTML = src/index.html

build: clean build-directory html js css

ship: rebase test feature-test build push deploy

deploy:
	cf push

push:
	git push

rebase:
	git pull --rebase

test: format
	$(BIN)/elm-test --yes --compiler=$(shell pwd)/$(BIN)/elm-make

feature-test: build
	./feature-tests.sh

keep-building:
	$(BIN)/chokidar "$(SRC)" "$(CSS)" -c "make"

keep-testing: format
	$(BIN)/elm-test --yes --watch --compiler=$(shell pwd)/$(BIN)/elm-make

format:
	$(BIN)/elm-format --yes $(SRC) $(TEST)

clean:
	rm -rf $(BUILD)

build-directory:
	mkdir -p $(BUILD)

html:
	cp $(HTML) $(BUILD)/index.html

js:
	$(BIN)/elm-make --yes $(SRC)/App.elm --output $(BUILD)/elm.js
	cp $(SRC)/native.js $(BUILD)/native.js

css:
	cp $(CSS)/*.css $(BUILD)/

serve: build
	$(BIN)/browser-sync start 	\
	--server $(BUILD) \
	--files $(BUILD) \
	--no-ui \
	--no-open \
	--no-notify \
	--port 8080

setup:
	yarn
