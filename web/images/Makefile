IMAGE_FILES = snitch.png

CONVERTER = inkscape  # filename.svg --export-png=filename.png


.SUFFIXES:
.SUFFIXES: .svg .png

all: build

build: $(IMAGE_FILES)


clean:
	rm -vf $(IMAGE_FILES)


.svg.png:
	$(CONVERTER) $< --export-png=$@.tmp
	pngcrush $@.tmp $@
	rm $@.tmp


.PHONY: build
