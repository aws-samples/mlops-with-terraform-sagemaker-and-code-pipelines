if [ -z "$DEPLOY_SAGEMAKER" ]
then
    echo SageMaker Pipeline not being deployed.
else
    echo Deploying SageMaker Pipeline via script.
    
    echo Retrieving Lambda ARN:
    LAMBDA_ARN=$(terraform -chdir="$CODEBUILD_SRC_DIR/$STACK_DIRECTORY" show -json | jq -r '.values.root_module.resources[] | select(.address=="aws_lambda_function.data_generation_lambda") | .values.arn')
    echo $LAMBDA_ARN

    echo Retrieving SageMaker role ARN:
    ROLE_ARN=$(terraform -chdir="$CODEBUILD_SRC_DIR/$STACK_DIRECTORY" show -json | jq -r '.values.root_module.resources[] | select(.address=="aws_iam_role.sagemaker_execution_role") | .values.arn')
    echo $ROLE_ARN

    echo "Script path: $PIPELINE_SCRIPT_PATH"
    python $CODEBUILD_SRC_DIR/$PIPELINE_SCRIPT_PATH \
        --pipeline_name "$STAGE-$PROJECT_NAME-pipeline" \
        --role_arn "$ROLE_ARN" \
        --generate_training_data_function_arn "$LAMBDA_ARN"
fi