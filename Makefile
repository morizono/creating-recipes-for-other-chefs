# ------------------
# TERRAFORM-MAKEFILE
# v0.11.13
# ------------------
#
# MAINTAINER: Bryan Nice
#
# This Makefile is used simplify the Terraform process.
# DO NOT copy and paste this anywhere outside the network.

# -------------
# INTERNAL VARIABLES
# -------------
# Read all subsquent tasks as arguments of the first task
# RUN_ARGS	:= $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
# $(eval $(args) $(RUN_ARGS):;@:)

BOLD		:=$(shell tput bold)
RED			:=$(shell tput setaf 1)
GREEN		:=$(shell tput setaf 2)
YELLOW		:=$(shell tput setaf 3)
RESET		:=$(shell tput sgr0)

terraform		:= $(shell command -v terraform 2> /dev/null)
docker			:= $(shell command -v docker 2> /dev/null)
docker-compose	:= $(shell command -v docker-compose 2> /dev/null)
gcloud			:= $(shell command -v gcloud 2> /dev/null)
python3			:= $(shell command -v python3 2> /dev/null)

# -------------
# VARIABLES
# -------------
STATEFILE_NAME := $(ENV)-$(TF_VAR_project_name).terraform.tfstate
ENV_VARS = "$(PWD)/deployments/terraform/environments/$(ENV)"

# -------------
# FUNCTIONS
# -------------
define set_project_var
	$(eval PROJECT=$(PWD)/deployments/terraform/recipes/$(1))
endef

define set_statefile_name
	$(eval STATEFILE_NAME=$(1).terraform.tfstate)
endef

# -------------
# TASKS
# -------------
.PHONY: build-tf-gcp
build-tf-gcp:
	@docker build --tag tf-gcp ./builds/terraform

.PHONY: build-jupyter-lab
build-jupyter-lab:
	@docker build --tag presentation ./builds/jupyter-lab

.PHONY: clean
clean:
	@rm -rf beconf.tfvarse
	@rm -rf beconf.tfvars
	@rm -rf .terraform
	@rm -rf .terraform.d
	@rm -rf *.terraform.tfstate
	@rm -rf errored.tfstate
	@rm -rf crash.log

.PHONY: login
login:
	@gcloud auth application-default login
	@gcloud auth login

.PHONY: set-gcp-project
set-gcp-project:
	@gcloud config set project $(PROJECT_ID)

.PHONY: fmt
fmt:
	@cd $(PWD)/deployments/terraform; \
	terraform fmt $(PROJECT)

.PHONY: set-recipe
set-recipe:
	$(call set_project_var,$(RECIPE))
	$(call set_statefile_name,$(ENV)-$(RECIPE))

.PHONY: setup-backend
setup-backend:
	$(eval CHECK := $(shell gcloud projects list --filter=devops --format='value(name)'))
	@if [ -z $(CHECK) ]; then \
		PRJ_ID=devops-$(shell uuidgen -t | sed -E 's/-\w*$$//g' | sed -E 's/-//g'); \
		gcloud projects create $$PRJ_ID --name="devops"; \
		gcloud alpha billing accounts projects link $$PRJ_ID --billing-account $(TF_VAR_billing_account); \
		gcloud services enable storage-component.googleapis.com storagetransfer.googleapis.com --project $$PRJ_ID; \
	fi

.PHONY: setup-storage-bucket
setup-storage-bucket:
	$(eval PRJ_ID := $(shell gcloud projects list --filter=devops --format='value(project_id)' --limit 1))
	$(eval CHECK := $(shell gsutil ls -p $(PRJ_ID)))
	@if [ -z $(CHECK) ]; then \
		gsutil mb -p $$PRJ_ID -l us -c multi_regional gs://$(PRJ_ID); \
	fi

.PHONY: init
init: set-recipe fmt login
	@cd $(PWD)/deployments/terraform; \
	if [ ! -f "./beconf.tfvars" ]; then \
		cp templates/beconf.sample.tfvars beconf.tfvars; \
		sed -ie '/^billing_account/s/\"\"/\"$(TF_VAR_billing_account)\"/g' beconf.tfvars; \
		sed -ie '/^project_name/s/\"\"/\"$(TF_VAR_project_name)\"/g' beconf.tfvars; \
	else \
		sed -ie '/^billing_account/s/\".*\"/\"$(TF_VAR_billing_account)\"/g' beconf.tfvars; \
		sed -ie '/^project_name/s/\"\"/\"$(TF_VAR_project_name)\"/g' beconf.tfvars; \
	fi;\
	terraform init \
		-input=false \
		-backend-config=beconf.tfvars \
		$(PROJECT); \
	echo "$(BOLD)Updating TF modules$(RESET)"; \
	terraform get -update=true $(PROJECT);

.PHONY: plan
plan: init
	@echo "$(BOLD)$(YELLOW)Planning..$(RESET)"
	@cd $(PWD)/deployments/terraform; \
	terraform plan \
		-input=false \
		-refresh=true \
		-var-file=beconf.tfvars \
		-var-file=$(ENV_VARS)/common.tfvars \
		$(PROJECT)

.PHONY: gcp-project
gcp-project: init
	@echo "$(BOLD)$(YELLOW)Provision GCP Project..$(RESET)"
	@cd $(PWD)/deployments/terraform; \
	terraform apply \
		-input=false \
		-refresh=true \
		-var-file=beconf.tfvars \
		-var-file=$(ENV_VARS)/common.tfvars \
		$(PROJECT)

.PHONY: gcp-kubeflow
gcp-kubeflow: login set-gcp-project
	@echo "$(BOLD)$(YELLOW)Provision GCP Kubeflow..$(RESET)"
	cd $(PWD)/deployments/terraform; \
	kfctl init $(KFAPP) --platform gcp --project $(PROJECT_ID) --use_basic_auth -V && \
		cd $(KFAPP) && \
		kfctl generate all -V --zone ${ZONE} --email ${EMAIL} && \
		kfctl apply all -V

.PHONY: gcp-pachyderm
gcp-pachyderm: login set-gcp-project
	@echo "$(BOLD)$(YELLOW)Deploying Pachyderm on K8..$(RESET)"
	cd $(PWD)/deployments/terraform; \
	pachctl deploy google $(BUCKET_NAME) $(BUCKET_SIZE) --dynamic-etcd-nodes=$(NODE_NUM)

