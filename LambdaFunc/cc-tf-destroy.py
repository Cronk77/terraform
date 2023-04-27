import os
import boto3
from python_terraform import *

def lambda_handler(event, context):
    #!/bin/python
    # Set the S3 bucket and state file name
    s3 = boto3.client('s3')
    bucket_name = 'cc-aline-ecs-bucket'
    state_file_key = 'terraform_state_two.tfstate'
    # # Download the state file from S3 to /tmp
    s3.download_file(bucket_name, state_file_key, '/tmp/terraform.tfstate')
    # tf = Terraform(working_dir='../cc-terraform-ecs')
    tf = Terraform(working_dir='/tmp/')
    print(tf.init())
    print(tf.plan(no_color=IsFlagged, refresh=False, capture_output=True))
    # print(tf.apply(skip_plan=True, capture_output=True))
    print(tf.apply(destroy=True, auto_approve=True, capture_output=True))
