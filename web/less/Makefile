LESS_SCRIPTS = snitch.css

LESSC = lessc
LESSCFLAGS = -x
STATIC = static

.SUFFIXES:
.SUFFIXES: .less .css


all: build


build: $(LESS_SCRIPTS)


clean:
	rm -vf $(LESS_SCRIPTS)


.less.css:
	$(LESSC) $(LESSCFLAGS) $< > $@


.PHONY: build
