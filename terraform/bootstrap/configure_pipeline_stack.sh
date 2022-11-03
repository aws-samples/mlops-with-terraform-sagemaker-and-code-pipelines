# This file will automatically set a .tfvars and Terraform backend file in the `stack` Terraform repo.
TARGET_BACKEND_FILEPATH="../pipeline/config.s3.tfbackend"
TARGET_TFVARS_FILEPATH="../pipeline/default.tfvars"

# Following deployment of the stack, we get the stack details.
TFSTATE=$(terraform show -json)

# We have a function to automatically pull values out of the stack details.
extract_tf_property () {
    retval=$(echo $TFSTATE | jq -r ".values.root_module.resources[] | select(.address==\"$1\") | .values.$2")
}

# We then extract some relevant ARNs and names.
extract_tf_property aws_codecommit_repository.pipeline_repo repository_name
REPOSITORY_NAME=$retval
extract_tf_property aws_s3_bucket.terraform_state_bucket bucket
TERRAFORM_STATE_BUCKET_NAME=$retval
extract_tf_property aws_dynamodb_table.terraform_state_lock name
TERRAFORM_STATE_LOCK_TABLE_NAME=$retval
extract_tf_property aws_s3_bucket.terraform_state_bucket region
REGION=$retval

# And we use this to conveniently set some config files. 
# First, the TF config backend:
echo "" > $TARGET_BACKEND_FILEPATH
echo "bucket=\"$TERRAFORM_STATE_BUCKET_NAME\"" >> $TARGET_BACKEND_FILEPATH
echo "key=\"dev-pipeline-deploy/terraform.tfstate\"" >> $TARGET_BACKEND_FILEPATH
echo "dynamodb_table=\"$TERRAFORM_STATE_LOCK_TABLE_NAME\"" >> $TARGET_BACKEND_FILEPATH
echo "region=\"$REGION\"" >> $TARGET_BACKEND_FILEPATH

# Next, the TF variables:
echo "" > $TARGET_TFVARS_FILEPATH
echo "repository_name=\"$REPOSITORY_NAME\"" >> $TARGET_TFVARS_FILEPATH
echo "terraform_state_bucket_name=\"$TERRAFORM_STATE_BUCKET_NAME\"" >> $TARGET_TFVARS_FILEPATH
echo "terraform_state_lock_table_name=\"$TERRAFORM_STATE_LOCK_TABLE_NAME\"" >> $TARGET_TFVARS_FILEPATH
echo "region=\"$REGION\"" >> $TARGET_TFVARS_FILEPATH

# Finally, we push this repository to AWS CodeCommit as a new origin if it's not available
if git remote -v | grep "codecommit" 
then
    echo "CodeCommit git remote already exists."
else
    echo "CodeCommit git remote does not exist. Setting new remote named \"codecommit\"".
    git remote add codecommit codecommit::$REGION://$REPOSITORY_NAME
fi
git push codecommit