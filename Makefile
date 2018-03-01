.PHONY: build
build: clean
	@gem build qmk_cli.gemspec

.PHONY: install
install:
	@gem install *.gem

.PHONY: uninstall
uninstall:
	@gem install qmk-cli

.PHONY: publish
publish: build
	@gem push *.gem

.PHONY: clean
clean:
	@rm -f *.gem
