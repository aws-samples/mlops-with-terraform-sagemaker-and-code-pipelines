if [ -z "$DEPLOY_SAGEMAKER" ]
then
    echo SageMaker solution is not being deployed.
else
    echo Running acceptance tests.
    pytest \
      --pipeline_name="$STAGE-$PROJECT_NAME-pipeline" \
      src/mlsolution/acceptance_tests/ 
fi