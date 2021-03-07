.PHONY: setup deploy

### CREATE AND SET func.tfvars FIRST ### 


FUNCTION = $(shell node -p "require('./temp_infra/func.json').app_functions.name")
STORAGE_ACC = $(shell node -p "require('./temp_infra/func.json').app_functions.storage_account")
STORAGE_SUB = 's/""/"$(STORAGE_ACC)"/g'

# Deploy function app including service plan and applicaton insights
.ONESHELL:
setup:
	cd infra/
	terraform init 
	terraform apply -var-file=func.tfvars -auto-approve

# Optional: used to init a azure function app
init:
	func init functions --node
	chmod 777 functions/local.settings.json
	sed -i $(STORAGE_SUB) functions/local.settings.json

# Optional: use it to add a new function
.ONESHELL:
add:
	cd functions/
	func new 

# Optional: Use this to run the function app locally. Remember to add env vars in local.settings.json
.ONESHELL:
run:
	cd functions/
	func start 

# Deploy Azure Functions
.ONESHELL:
deploy:
	cd functions/
	func azure functionapp publish $(FUNCTION)


.ONESHELL:
destroy:
	cd infra/
	terraform destroy  -var-file=func.tfvars -auto-approve
