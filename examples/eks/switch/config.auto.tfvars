source_location           = "https://github.com/mohzim/microservices-eks-devops.git"
kill_resources_schedule   = "cron(40 1/1 * * ? *)"
revive_resources_schedule = "cron(0 1/1 * * ? *)"
init_command              = "terraform -chdir=terraform init -backend-config=\"bucket=mohzim-terraform\" -backend-config=\"key=terraform-microservices-eks-devops-tfstate\" -backend-config=\"region=ap-south-1\" -input=false" # Replace all fields of REPLACE_ME with your s3 backend configuration values that is used to deploy the MWAA environment.
kill_command              = "terraform -chdir=terraform destroy -input=false -auto-approve"
revive_command            = "terraform -chdir=terraform apply -input=false -auto-approve"
tf_backend_bucket         = "mohzim-terraform"
tf_backend_key            = "terraform-aws-scheduled-switch-tfstate"