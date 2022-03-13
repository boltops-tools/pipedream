class Pipedream::Builder::Pipeline
  class S3Bucket
    extend Memoist
    include Pipedream::AwsServices

    class << self
      extend Memoist
      def name
        new.name
      end
      memoize :name
    end

    def name
      ensure_exists(bucket_name)
      bucket_name
    end
    memoize :name

    def bucket_name
      "codepipeline-#{aws.region}-#{aws.account}"
    end

    def ensure_exists(name)
      return if exists?(name) || ENV['TEST']
      s3.create_bucket(bucket: name)
      policy =<<~EOL
        ---
        Version: '2012-10-17'
        Id: SSEAndSSLPolicy
        Statement:
        - Sid: DenyUnEncryptedObjectUploads
          Effect: Deny
          Principal: "*"
          Action: s3:PutObject
          Resource: arn:aws:s3:::#{name}/*
          Condition:
            StringNotEquals:
              S3:x-amz-server-side-encryption: aws:kms
        - Sid: DenyInsecureConnections
          Effect: Deny
          Principal: "*"
          Action: s3:*
          Resource: arn:aws:s3:::#{name}/*
          Condition:
            Bool:
              Aws:SecureTransport: 'false'
      EOL
      s3.put_bucket_policy(
        bucket: name,
        policy: JSON.dump(policy),
      )
    rescue Aws::S3::Errors::BucketAlreadyExists => e
      puts "ERROR #{e.class}: #{e.message}".color(:red)
      puts "Bucket name: #{name}"
      exit 1
    end

    def exists?(name)
      begin
        s3.head_bucket(bucket: name)
        true
      rescue Aws::S3::Errors::BucketAlreadyOwnedByYou, Aws::S3::Errors::Http301Error
        # These exceptions indicate bucket already exists
        # Aws::S3::Errors::Http301Error could be inaccurate but compromising for simplicity
        true
      rescue
        false
      end
    end
  end
end
