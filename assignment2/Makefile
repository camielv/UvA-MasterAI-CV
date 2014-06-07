all: data/TeddyBear/obj02_001.png vlfeat/bin/

data/TeddyBear/obj02_001.png: data.zip
	unzip data.zip
	touch data/TeddyBear/obj02_001.png

data.zip:
	wget -c https://googledrive.com/host/0B066imImC1CgWHB0aXhlUEItX2M --no-check-certificate -O data.zip

vlfeat/:
	git clone git://github.com/vlfeat/vlfeat.git

vlfeat/bin/: vlfeat/
	@echo "Please run the following command from the vlfeat/ folder:\nmake MEX=YOUR_MATLAB_DIR/bin/mex"

.PHONY: clean
clean:
	rm data.zip
	rm -rf data/
	rm -rf vlfeat/
