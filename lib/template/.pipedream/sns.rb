# If user has specified their own existing SNS topic ARN, then this SNS Topic managed by the codepipeline
# tool will not get created. Also, only gets created if there's an approval action in the pipeline.
#
# Example properties:
#
#   https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-sns-topic.html
#
# display_name "my display_name"
# kms_master_key_id "String"
# subscription([{
#   Endpoint: '',
#   Protocol: ','
# }])
# topic_name "string", # Recommend not setting because update requires: Replacement. Allow CloudFormation to set it so 2 pipelines dont have same SNS Topic name that collides
