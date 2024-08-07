ARCH=`gcc -dumpmachine`
ifeq "$(findstring mac, $(ARCH))" "mac"
CMD_DESTDIR ?= ~/Library/Application\ Support/Google/Chrome/NativeMessagingHosts
else
CMD_DESTDIR ?= ~/.config/google-chrome/NativeMessagingHosts
endif

PREFIX ?= $(CURDIR)/out/

PKG=github.com/maceip/tlsn-vsock
VERSION=$(shell git describe --match 'v[0-9]*' --dirty='.m' --always --tags)
REVISION=$(shell git rev-parse HEAD)$(shell if ! git diff --no-ext-diff --quiet --exit-code; then echo .m; fi)
GO_EXTRA_LDFLAGS=-extldflags '-static'
GO_LD_FLAGS=-ldflags '-s -w -X $(PKG)/version.Version=$(VERSION) -X $(PKG)/version.Revision=$(REVISION) $(GO_EXTRA_LDFLAGS)'
GO_BUILDTAGS=-tags "osusergo netgo static_build"

all: tlsn-vsock

build: tlsn-vsock


tlsn-vsock:
	CGO_ENABLED=0 go build -o $(PREFIX)/tlsn-vsock $(GO_LD_FLAGS) $(GO_BUILDTAGS) -v ./cmd/tlsn-vsock


install:
	mkdir -p $(CMD_DESTDIR)/xyz.mac.mac/
	install  -m 755 $(PREFIX)/tlsn-vsock $(CMD_DESTDIR)/xyz.mac.mac/

artifacts: clean
	GOOS=linux GOARCH=amd64 make tlsn-vsock
	tar -C $(PREFIX) --owner=0 --group=0 -zcvf $(PREFIX)/build-$(VERSION)-linux-amd64.tar.gz tlsn-vsock

	rm -f $(PREFIX)/tlsn-vsock

clean:
	rm -f $(CURDIR)/out/*
