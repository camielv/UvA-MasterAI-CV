all: data/0000000000.pcd

data/0000000000.pcd: data.zip
	unzip data.zip
	touch data/0000000000.pcd

data.zip:
	wget -c https://googledrive.com/host/0BxqEJ5Xwfi63SnlsVkloSVkzdk0 --no-check-certificate -O data.zip

.PHONY: clean
clean:
	rm data.zip
	rm -rf data/
