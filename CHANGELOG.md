# Change Log

All notable changes to this project will be documented in this file.
This project *loosely* adheres to [Semantic Versioning](http://semver.org/), even before v1.0.

## [0.4.5]
- add aws codepipeline get-pipeline-state command hint in output also
- dont autocamelize code build project name
- #3 fix typo

## [0.4.4]
- add mfa support for normal IAM user

## [0.4.3]
- fix pipedream renaming

## [0.4.2]
- fix project_name

## [0.4.1]
- remove codebuild_prefix and codebuild_suffix helpers

## [0.4.0]
- rename to pipedream

## [0.3.3]
- allow no settings.yml file

## [0.3.2]
- update vendor/aws_data

## [0.3.1]
- fix gem dependencies in vendor

## [0.3.0]
- update docs and cli help

## [0.2.1]
- fix different branch check

## [0.2.0]
- DSL: pipeline, role, schedule, webhook, sns
- pipe deploy -b branch
- pipe start -b branch
- pipe cli commands: init deploy, start, delete
- ssm support
- codebuild\_prefix and codebuild\_suffix support
- auto-create s3 bucket for artifacts

## [0.1.0]
- Initial release.
