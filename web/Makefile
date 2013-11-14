all: clean static


clean:
	rm -rf static
	make -C less clean
	make -C images clean


build:
	make -C less build
	make -C images build


static: build
	mkdir -p static
	mv less/snitch.css static/snitch.css
	mkdir -p static/images
	mv images/*png static/images/


.PHONY: clean build all
