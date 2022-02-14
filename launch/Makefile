#!make
-include ./properties.gitignore
.DEFAULT_GOAL := help
RUN_INSTANCES_TMP_FILE := run_instances.out.gitignore

help:
	@echo Deploy Instance into VPC
	@echo make [launch]

launch:
	./launch.sh

test:
	aws sts get-caller-identity > tmp.out.gitignore
	$(eval ID := $(shell cat tmp.out.gitignore | jq -r '.Arn'))
	@echo "ID: $(ID)"

