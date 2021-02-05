# terraform apply -var-file="secret.tfvars"
# or: Set values with environment variables
#$ export TF_VAR_db_username=admin TF_VAR_db_password=adifferentpassword
# You would want to ignore or exclude *.tfvars in git checks ins
db_username = "admin"
dp_password = "justanotherweakpass"