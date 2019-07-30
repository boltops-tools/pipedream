---
title: Overview
nav_order: 2
---

## What is codepipeline?

Codepipeline is a tool that simplifies creating and managing [AWS CodePipeline](https://aws.amazon.com/codepipeline/) resources. It provides a DSL to create a Pipeline, Scheduled Event, IAM Role, and Webhook.

The DSL is essentially a wrapper to the CloudFormation for resources like the [CodePipeline Project resource](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-codepipeline-pipeline.html). This means you can **fullly control** and customize of the CodePipeline resources.

## Usage Scenarios

Here are some ways to use CodePipeline:

* continously integration and delivery
* deploying code
* building artifacts

## CodePipeline vs CodeBuild

CodePipeline is a higher level software than CodeBuild. CodeBuild is a managed build service and you can use it to automated tasks. CodePipeline helps you visualize the steps and puts it altogether.

{% include prev_next.md %}