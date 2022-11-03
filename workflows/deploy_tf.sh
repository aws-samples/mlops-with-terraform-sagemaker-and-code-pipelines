terraform \
    -chdir="$CODEBUILD_SRC_DIR/$STACK_DIRECTORY" \
    init \
    -input=false \
    -backend-config="region=$TF_VAR_region" \
    -backend-config="bucket=$TF_VAR_terraform_state_bucket_name" \
    -backend-config="key=$TF_VAR_terraform_state_key" \
    -backend-config="dynamodb_table=$TF_VAR_terraform_state_lock_table_name"
terraform \
    -chdir="$CODEBUILD_SRC_DIR/$STACK_DIRECTORY" \
    plan \
    -input=false 
terraform \
    -chdir="$CODEBUILD_SRC_DIR/$STACK_DIRECTORY" \
    apply \
    -auto-approve \
    -input=false 