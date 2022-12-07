
init:             terraform init

build-taiwan:     validate
			      terraform workspace  new taiwan  || terraform workspace select taiwan  && terraform apply -var-file envs/regions/asia-east1/asia-east1.tfvars -auto-approve


build-australia:  validate
				  terraform workspace new australia || terraform workspace select australia  && terraform apply -var-file envs/regions/australia-southeast1/australia-southeast1.tfvars -auto-approve

build-london:     validate
			      terraform workspace new london  || terraform workspace select london  &&  terraform apply -var-file envs/regions/europe-west2/europe-west2.tfvars -auto-approve

build-california: validate
			      terraform workspace new california  || terraform workspace select california  &&  terraform apply -var-file envs/regions/us-west2/us-west2.tfvars -auto-approve


destroy-taiwan: 
				terraform workspace select taiwan && terraform destroy -var-file envs/regions/asia-east1/asia-east1.tfvars 


destroy-australia:
				terraform workspace select australia && terraform destroy -var-file envs/regions/australia-southeast1/australia-southeast1.tfvars 

destroy-london: 
				terraform workspace select london && terraform destroy -var-file envs/regions/europe-west2/europe-west2.tfvars 

destroy-california: 
				    terraform workspace select california && terraform destroy -var-file envs/regions/us-west2/us-west2.tfvars





