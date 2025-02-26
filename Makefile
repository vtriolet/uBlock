.PHONY: all clean install chromium firefox nodejs install-nodejs-link install-nodejs uninstall-nodejs

sources := $(wildcard src/* src/*/* src/*/*/* src/*/*/*/*)
platform := $(wildcard platform/* platform/*/*)
assets := $(wildcard submodules/uAssets/* \
                     submodules/uAssets/*/* \
                     submodules/uAssets/*/*/* \
                     submodules/uAssets/*/*/*/*)

all: chromium firefox nodejs

dist/build/uBlock0.chromium: $(sources) $(platform) $(assets)
	tools/make-chromium.sh

# Build the extension for Chromium.
chromium: dist/build/uBlock0.chromium

dist/build/uBlock0.firefox: $(sources) $(platform) $(assets)
	tools/make-firefox.sh all

# Build the extension for Firefox.
firefox: dist/build/uBlock0.firefox

dist/build/uBlock0.nodejs: $(sources) $(platform) $(assets)
	tools/make-nodejs.sh

# Build the Node.js package.
nodejs: dist/build/uBlock0.nodejs

# Install the Node.js package as a link in the node_modules directory. This is
# convenient for development, but it breaks when the dist/build directory is
# cleaned up.
install-nodejs-link: dist/build/uBlock0.nodejs
	npm install dist/build/uBlock0.nodejs --no-save

dist/build/uBlock0.nodejs.tgz: dist/build/uBlock0.nodejs
	tar czf dist/build/uBlock0.nodejs.tgz --strip-components 2 dist/build/uBlock0.nodejs

# Install the Node.js package.
install-nodejs: dist/build/uBlock0.nodejs.tgz
	npm install dist/build/uBlock0.nodejs.tgz --no-save

# Uninstall the Node.js package.
uninstall-nodejs:
	npm uninstall uBO-snfe --no-save

clean:
	rm -rf dist/build
