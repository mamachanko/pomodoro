SRC = src
TEST = tests
BUILD = build
CSS = styles
HTML = src/index.html

build: clean build-directory html js css

keep-building:
	chokidar "$(SRC)" "$(CSS)" -c "make"

ship: test build rebase deploy

deploy:
	cf push

rebase:
	git pull --rebase

test: format
	elm-test --yes

keep-testing: format
	elm-test --yes --watch

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

serve:
	browser-sync start 	\
	--server $(BUILD) \
	--files $(BUILD) \
	--no-ui \
	--no-notify \
	--port 8080
