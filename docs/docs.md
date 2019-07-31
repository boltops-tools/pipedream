---
title: Overview
nav_order: 2
---

## What is codepipeline?

The codepipeline tool provides a DSL that simplifies creating and managing [AWS CodePipeline](https://aws.amazon.com/codepipeline/) resources. You create a Pipeline, Scheduled Event, IAM Role, and Webhook.

The DSL is essentially a wrapper to CloudFormation for resources like the [CodePipeline Project resource](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-codepipeline-pipeline.html). This means you can **fully control** and customize of the CodePipeline resources.

## Usage Scenarios

Here are some ways to use CodePipeline:

* continuous integration and delivery
* visualizing the deploy flow
* building artifacts: Docker images, AMIs, jars, s3 objects, etc

## CodePipeline vs CodeBuild

CodePipeline is higher-level software than CodeBuild. CodeBuild is a managed build service, and you can use it to automate tasks. CodePipeline helps you sequence the steps and puts it all together; providing you with a high-level visualization.

{% include prev_next.md %}
