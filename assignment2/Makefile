all: data/TeddyBear/obj02_001.png

data/TeddyBear/obj02_001.png: data.zip
	unzip data.zip
	touch data/TeddyBear/obj02_001.png

data.zip:
	#wget -c https://googledrive.com/host/0BxqEJ5Xwfi63SnlsVkloSVkzdk0 --no-check-certificate -O data.zip

clean:
	rm data.zip
	rm -rf data/
