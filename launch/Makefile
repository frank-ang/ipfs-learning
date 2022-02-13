#!make
-include ./properties.gitignore
.DEFAULT_GOAL := help
RUN_INSTANCES_TMP_FILE := run_instances.out.gitignore

help:
	@echo Deploy Instance into VPC
	@echo make [launch]

launch:
	@echo launching ubuntu instance...
	@#aws ec2 run-instances \
		--image-id ${AMI} \
		--instance-type r5a.large \
		--key-name ${KEYPAIR} \
		--security-group-ids ${SECURITY_GROUP_IDS} \
		--subnet-id ${SUBNET_ID} \
		--iam-instance-profile "Name=${IAM_INSTANCE_PROFILE_NAME}" \
		--block-device-mapping "DeviceName=/dev/sda1,Ebs={VolumeSize=30,VolumeType=gp3}" \
		--tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=filecoin}]' 'ResourceType=volume,Tags=[{Key=Name,Value=filecoin}]' > ${RUN_INSTANCES_TMP_FILE}
	sleep 1
	$(eval INSTANCE_ID := $(shell cat $(RUN_INSTANCES_TMP_FILE) | jq -r '.Instances[0].InstanceId'))
	@echo Awaiting EC2 InstanceID $(INSTANCE_ID) status...
	aws ec2 wait instance-status-ok --instance-ids $(INSTANCE_ID)
	@echo EC2 InstanceID $(INSTANCE_ID) started.
	aws ec2 associate-address --instance-id $(INSTANCE_ID) --allocation-id $(EIPALLOC_ID)

#		--user-data file://userdata-ubuntu-lotus.txt 

test:
	aws sts get-caller-identity > tmp.out.gitignore
	$(eval ID := $(shell cat tmp.out.gitignore | jq -r '.Arn'))
	@echo "ID: $(ID)"

