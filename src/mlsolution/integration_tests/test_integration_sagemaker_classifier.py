import os
from sagemaker.sklearn.estimator import SKLearn
from mlsolution.get_data_lambda import iris_data_filepath
import mlsolution
import sagemaker

sagemaker_session = sagemaker.Session()
role = sagemaker.get_execution_role()
source_dir = os.path.abspath(os.path.split(mlsolution.__file__)[0])
dependencies_dir = os.path.abspath(os.path.join(os.path.split(mlsolution.__file__)[0], ".."))

inspectlocal = False

def test_training_script_in_local_container():
    sklearn = SKLearn(
        entry_point="sagemaker_classifier.py",
        source_dir=source_dir,
        dependencies_dir=dependencies_dir,
        role=role,
        py_version="py3",
        framework_version="0.20.0",
        instance_type="local"
    )
    sklearn.fit(inputs={
        "train": "file://" + iris_data_filepath
        })
    pass
