from sagemaker.workflow.lambda_step import LambdaStep, LambdaOutput, LambdaOutputTypeEnum
from sagemaker.workflow.steps import TrainingStep
from sagemaker.workflow.pipeline import Pipeline
from sagemaker.workflow.parameters import ParameterString
from sagemaker.inputs import TrainingInput
from sagemaker.lambda_helper import Lambda
from sagemaker.sklearn.estimator import SKLearn
import argparse

import mlsolution
import os
source_dir = os.path.abspath(os.path.split(mlsolution.__file__)[0])
dependencies_dir = os.path.abspath(os.path.join(os.path.split(mlsolution.__file__)[0], ".."))


def create_pipeline(
    pipeline_name: str,
    role_arn: str, 
    generate_training_data_function_arn: str
    ):

    # Define our parameters
    training_instance_type = ParameterString(
        name="training_instance_type", 
        default_value="ml.m5.xlarge"
    )

    # Define our training step
    step_lambda_generate_training_dataset = LambdaStep(
        name="LambdaStepGenerateTrainingDataset",
        display_name="Lambda - generate training dataset",
        description="Run a Lambda that generates a training dataset.",
        lambda_func=Lambda(
            function_arn=generate_training_data_function_arn
        ),
        inputs={
        },
        outputs=[
            LambdaOutput(
                output_name="bucket",
                output_type=LambdaOutputTypeEnum.String
            ),
            LambdaOutput(
                output_name="key",
                output_type=LambdaOutputTypeEnum.String
            ),
            LambdaOutput(
                output_name="s3_address",
                output_type=LambdaOutputTypeEnum.String
            )
        ]
    )

    # Define our training step
    inputs = {
        "train": TrainingInput(
            step_lambda_generate_training_dataset.properties.Outputs[
                "s3_address"
            ],
            content_type="text/csv"
        )
    }
    sklearn = SKLearn(
        entry_point="sagemaker_classifier.py",
        source_dir=source_dir,
        dependencies_dir=dependencies_dir,
        role=role_arn,
        py_version="py3",
        framework_version="0.20.0",
        instance_type=training_instance_type
    )
    step_training = TrainingStep(
        name="TrainingStep", 
        estimator=sklearn, 
        inputs=inputs
    )

    # Create the Pipeline
    pipeline = Pipeline(
        name=pipeline_name,
        parameters=[
            training_instance_type
        ],
        steps=[
            step_lambda_generate_training_dataset,
            step_training
        ]
    )

    return pipeline


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--pipeline_name", type=str)
    parser.add_argument("--role_arn", type=str)
    parser.add_argument(
        "--generate_training_data_function_arn", type=str
    )
    args, _ = parser.parse_known_args()

    pipeline = create_pipeline(
        pipeline_name=args.pipeline_name,
        role_arn=args.role_arn,
        generate_training_data_function_arn=args.generate_training_data_function_arn
    )
    pipeline.upsert(role_arn=args.role_arn)


if __name__ == "__main__":
    main()
