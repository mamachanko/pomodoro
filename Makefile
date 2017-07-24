SRC = src
TEST = tests
BUILD = build
CSS = styles
HTML = src/index.html

build: test clean build-directory html js css

ship: build rebase deploy

deploy:
	cf push

rebase:
	git pull --rebase

test: format
	elm-test --yes

format:
	elm-format --yes $(SRC) $(TEST)

clean:
	rm -rf $(BUILD)

build-directory:
	mkdir -p $(BUILD)

html:
	cp $(HTML) $(BUILD)/index.html

js:
	elm-make --yes $(SRC)/App.elm --output $(BUILD)/elm.js
	cp $(SRC)/native.js $(BUILD)/native.js

css:
	cp $(CSS)/*.css $(BUILD)/
