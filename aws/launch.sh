#!/bin/bash
. ./properties.gitignore

RUN_INSTANCES_TMP_FILE=run_instances.out.gitignore
rm $RUN_INSTANCES_TMP_FILE

echo launching ubuntu instance...
aws ec2 run-instances \
    --image-id $AMI \
    --instance-type $INSTANCE_TYPE \
    --key-name $KEYPAIR \
    --security-group-ids $SECURITY_GROUP_IDS \
    --subnet-id $SUBNET_ID \
    --iam-instance-profile "Name=$IAM_INSTANCE_PROFILE_NAME" \
    --block-device-mapping "DeviceName=/dev/sda1,Ebs={VolumeSize=200,VolumeType=gp3}" \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=lotus-miner},{Key=project,Value=filecoin}]' 'ResourceType=volume,Tags=[{Key=Name,Value=lotus-miner}]' \
    --user-data file://userdata-ubuntu-lotus.txt >  $RUN_INSTANCES_TMP_FILE

sleep 1
INSTANCE_ID=`cat $RUN_INSTANCES_TMP_FILE | jq -r '.Instances[0].InstanceId'`
echo Awaiting EC2 InstanceID $INSTANCE_ID status...
aws ec2 wait instance-status-ok --instance-ids $INSTANCE_ID
echo EC2 InstanceID $INSTANCE_ID started. Associating address...

aws ec2 associate-address --instance-id $INSTANCE_ID --allocation-id $EIPALLOC_ID

echo done.