all: tar

container:
	sudo docker build -t docker-vpn-client .

run: container
	sudo docker run -a stdin -a stdout -a stderr -i -t docker-vpn-client

tar: container
	sudo docker save docker-vpn-client | gzip > vpn-client.tgz

clean:
	sudo docker rm $(docker ps -a -q)
	sudo docker rmi $(docker images -q)
	rm -f vpn-client.tgz
