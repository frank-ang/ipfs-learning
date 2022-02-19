#!make
-include ./properties.gitignore
.DEFAULT_GOAL := help
RUN_INSTANCES_TMP_FILE := run_instances.out.gitignore

help:
	@echo Deploy Instance into VPC
	@echo make [launch|describe|stop|start]

launch:
	./launch.sh

describe:
	aws ec2 describe-instances --filters "Name=tag:Name,Values='*lotus*'" \
		--query "Reservations[*].Instances[*].{Instance:InstanceId,Name:Tags[?Key=='Name']|[0].Value,State:State.Name}" \
		--output table

stop: get-instance-id
	@echo stopping instance id $(INSTANCE_ID) ...
	aws ec2 stop-instances --instance-ids $(INSTANCE_ID)

start: get-instance-id
	@echo starting instance id $(INSTANCE_ID) ...
	aws ec2 start-instances --instance-ids $(INSTANCE_ID)

get-instance-id:
	@echo getting instance id of lotus-lite...
	$(eval INSTANCE_ID := $(shell \
	aws ec2 describe-instances --filters "Name=tag:Name,Values='lotus-lite'" \
	 	--query "Reservations[*].Instances[*].{Instance:InstanceId}" --output text ))