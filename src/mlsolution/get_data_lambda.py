import logging
import boto3
import os
import datetime
import mlsolution

logger = logging.getLogger()
logger.setLevel(logging.INFO)


data_dir = os.path.dirname(os.path.abspath(mlsolution.__file__)) + "/data"
iris_data_filepath = os.path.join(data_dir, "iris.csv")


s3 = boto3.resource("s3")


BUCKET_NAME = os.environ.get("BUCKET_NAME", None)


def write_dataset_to_s3(bucket_name=BUCKET_NAME):
    bucket = s3.Bucket(name=bucket_name)
    key = os.path.join("datasets", datetime.datetime.now().isoformat(), "training.csv")
    bucket.upload_file(
        iris_data_filepath,
        key
        )
    return {
        "bucket": bucket_name,
        "key": key,
        "s3_address": "s3://{}/{}".format(bucket_name, key)
    }


def lambda_handler(event, context):
    logger.info(event)
    outputs = write_dataset_to_s3(bucket_name=BUCKET_NAME)
    return {
        "statusCode": 200,
        **outputs
    }