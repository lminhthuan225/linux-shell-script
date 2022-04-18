#!/bin/bash

#terraform apply -lock=false -auto-approve


printDockerExposedPort() {
	DOCKER_CONTAINER_ID="$1"
	docker port $DOCKER_CONTAINER_ID | awk '{print $3}' | cut -d : -f 2
}

terraform output -json container_id | jq -r '.[0]' | jq -c '.[]' input.json | while read i; do
	printDockerExposedPort $i
done


