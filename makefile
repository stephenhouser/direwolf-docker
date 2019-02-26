#
# Direwolf - Amatuer Radio APRS Digipeater and Internet Gateway
#
# 
include ~/.ssh/container-secrets.txt

# Basic container setup
VM_NAME=$(shell /usr/bin/awk '/container_name: / {print $$2;}' docker-compose.yaml)
DATA_VOLUME=${VM_NAME}_data
TIMESTAMP=$(shell date +"%Y%m%dT%H%M%S")

IMAGE=$(shell /usr/bin/awk '/image: / {print $$2;}' docker-compose.yaml)

# For container backups
LAST_BACKUP=$(shell ls -t ${VM_NAME}-*.sql.gz | head -n1)
BACKUP_FILE=${VM_NAME}-${TIMESTAMP}.sql.gz

# Show the container and its volumes
default:
	echo ${VM_NAME}
	docker-compose ps

# Back up the container's data by exporting and compressing it
backup:
	@echo "backup: Not Implemented"

# Make a new container by restoring an existing database
restore: distclean
	@echo "restore: Not Implemented"
	#docker-compose up --no-start
	#docker-compose create
	#docker cp ${LAST_BACKUP} mariadb:/docker-entrypoint-initdb.d/
	#docker-compose start

test:
	@echo "test: Not Implemented"

build:
	docker build -t ${IMAGE} .
	#docker tag ${IMAGE} localhost:5000/${IMAGE}

push:
	docker push ${IMAGE}
	#docker push localhost:5000/${IMAGE}

# Make (and start) the container
run: container

container:
	#docker-compose up --no-start
	#docker cp direwolf.conf ${VM_NAME}:/direwolf/direwolf.conf
	docker-compose up -d

# Start an already existing container that has been stopped
start:
	docker-compose start

# Attach to a running contiainer with sh
attach:
	docker exec -it ${VM_NAME} /bin/sh

# Attach to a running container's console
console:
	screen -d -R -S ${VM_NAME} docker attach ${VM_NAME}

# Stop a running container
stop:
	docker-compose stop

# Update a container's image; stop, pull new image, and restart
update: clean
	-docker-compose pull ${DOCKER_IMAGE}
	make container 

# Delete container's volume (DANGER)
clean-volume:
	docker-compose down -v

# Delete a container (WARNNING)
clean: stop
	docker-compose down

# Delete a container and it's volumes (DANGER)
distclean: clean clean-volume
