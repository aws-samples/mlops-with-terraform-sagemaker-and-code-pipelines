import boto3
import pytest
import moto
from moto import mock_s3


DATASET_BUCKET_NAME = "example_bucket_name"


@pytest.fixture
def mock_s3_resource():
    with mock_s3():
        s3 = boto3.resource("s3", region_name="ap-southeast-2")
        s3.create_bucket(
            Bucket=DATASET_BUCKET_NAME,
            CreateBucketConfiguration={
                "LocationConstraint": "ap-southeast-2"
            })

        yield s3


def test_data_upload(mock_s3_resource):
    import mlsolution.get_data_lambda

    upload_location = mlsolution.get_data_lambda.write_dataset_to_s3(
        bucket_name=DATASET_BUCKET_NAME
    )
    
    objects = mock_s3_resource.Bucket(upload_location["bucket"]).objects.filter(Prefix=upload_location["key"], MaxKeys=1)
    assert any([obj.key == upload_location["key"] for obj in objects])