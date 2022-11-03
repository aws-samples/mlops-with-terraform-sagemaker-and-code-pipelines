import pytest
from datetime import datetime
import os
from sagemaker.workflow.pipeline import Pipeline




def test_ml_pipeline(pipeline_name: str):
    if pipeline_name == "":
        pytest.skip("No pipeline name provided!")

    print(pipeline_name)

    pipeline = Pipeline(name=pipeline_name)
    execution = pipeline.start(
        execution_display_name="acceptance-test-run-{}".format(int(datetime.now().timestamp()))
    )
    execution.wait()
    pipeline_execution_description = execution.describe()
    assert pipeline_execution_description["PipelineExecutionStatus"] == "Succeeded"