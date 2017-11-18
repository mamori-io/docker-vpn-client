all: container

container:
	sudo docker build -t docker-vpn-client .

run: container
	sudo docker run -a stdin -a stdout -a stderr -i -t docker-vpn-client

clean:
	sudo docker rm $(docker ps -a -q)
	sudo docker rmi $(docker images -q)
