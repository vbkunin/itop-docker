# itop-docker
Combodo iTop docker image

sudo docker build -t vbkunin/itop:2.2.0-beta .

sudo docker run -d -p 80:80 -p 3306:3306 --name=itop vbkunin/itop:2.2.0-beta

sudo docker run -d -p 80:80 -p 3306:3306 --name=itop -v /home/user/itop-extensions:/app/extensions vbkunin/itop:2.2.0-beta