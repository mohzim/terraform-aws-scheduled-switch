source_location           = "https://github.com/mohzim/microservices-eks-devops.git"
kill_resources_schedule   = "cron(40 1/1 * * ? *)"
revive_resources_schedule = "cron(0 1/1 * * ? *)"
init_command              = "terraform -chdir=examples/mwaa/environment init -backend-config=\"bucket=mohzim-terraform\" -backend-config=\"key=terraform-aws-scheduled-switch-tfstate\" -backend-config=\"region=ap-south-1\" -input=false" # Replace all fields of REPLACE_ME with your s3 backend configuration values that is used to deploy the MWAA environment.
kill_command              = "terraform -chdir=examples/mwaa/environment apply -input=false -target=aws_mwaa_environment.this -var enabled=false -auto-approve"
revive_command            = "terraform -chdir=examples/mwaa/environment apply -input=false -target=aws_mwaa_environment.this -var enabled=true -auto-approve"
tf_backend_bucket         = "mohzim-terraform"
tf_backend_key            = "terraform-aws-scheduled-switch-tfstate"