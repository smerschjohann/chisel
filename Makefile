
VERSION=$(shell git describe --abbrev=0 --tags)
LDFLAG=-ldflags "-X github.com/mcbernie/chisel/share.BuildVersion=$(VERSION)"
BUILDDIR=build
RELEASEDIR=release

.DEFAULT_GOAL := help

.PHONY: help build win32 win64



help: ## Print a description of all available targets
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

create-folder:
	mkdir -p $(BUILDDIR)
	mkdir -p $(RELEASEDIR)


clean: ## Cleans build adn release directory
	rm -rf $(BUILDDIR)/*
	rm -rf $(RELEASEDIR)/*

win32: create-folder ## Builds binary for windows 32b
	env GOOS=windows GOARCH=386 \
	go build $(LDFLAG) \
	-o $(BUILDDIR)/chisel32.exe

win64: ## Builds binary for windows 64b
	env GOOS=windows \
	go build $(LDFLAG) \
	-o $(BUILDDIR)/chisel64.exe

build: ## Builds binary
	go build $(LDFLAG) \
	-o $(BUILDDIR)/chisel

all: win32 win64 build ## Builds all

release: clean all ## Build all and create archiv with version number
	tar cfzv $(RELEASEDIR)/release-$(VERSION).tar.gz $(BUILDDIR)/chisel32.exe $(BUILDDIR)/chisel64.exe $(BUILDDIR)/chisel
	zip $(RELEASEDIR)/release-$(VERSION).zip $(BUILDDIR)/chisel32.exe $(BUILDDIR)/chisel64.exe $(BUILDDIR)/chisel
