all: tar

container:
	sudo docker build -t mamori-vpn-client .

run: container
	sudo docker run -a stdin -a stdout -a stderr -i -t mamori-vpn-client

tar: container
	sudo docker save mamori-vpn-client | gzip > vpn-client.tgz

clean:
	rm -f vpn-client.tgz
	sudo docker rmi $(docker images -q)
