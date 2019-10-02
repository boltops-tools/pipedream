---
title: 'ECS Deploy: Codebuild ufo ship vs CodePipeline ECS Deploy'
nav_order: 21
---

CodePipeline comes with many [Action Type Integrations](https://docs.aws.amazon.com/codepipeline/latest/userguide/integrations-action-type.html).  One of the Integrations is [Amazon Elastic Container Service](https://docs.aws.amazon.com/codepipeline/latest/userguide/integrations-action-type.html#integrations-deploy) deployment. It is recommended to use [codebuild and ufo](https://codebuild.cloud/docs/examples/ecs/) to handle deployment to ECS though.  We discuss some reasons below.

## Timeout

With the CodePipeline ECS Deploy if your ECS service fails to stabilize then the pipeline stage will not timeout until 60 minutes later. There is no built-in way to abort the pipeline stage. This is discussed here: [CodePipeline stage timeouts / abort?](https://forums.aws.amazon.com/thread.jspa?threadID=216350).

A workaround is discussed here: [How to stop an execution or set set timeout for an action in AWS CodePipeline?](https://stackoverflow.com/questions/50925732/how-to-stop-an-execution-or-set-set-timeout-for-an-action-in-aws-codepipeline/50929558) So to workaround waiting for 60 minutes, we can update the pipeline. This is a little bit inconvenient. By using a CodeBuild project, we have control over the timeout.

## It's Less Powerful

The way the current CodePipeline ECS Deploy Action works is that it pulls down the current ECS task definition of the ECS service. It then replaces the image property on it. Last, it then updates the ECS service with the newly built Docker image.

The [ufo tool](https://ufoships.com) is more powerful.  The `ufo ship` command also handles creating the [ELB Load Balancer]((https://ufoships.com/docs/extras/load-balancer/)) and a vanity [Route53 endpoint](https://ufoships.com/docs/extras/route53-support/) for us.  Also, it keeps task definitions codified.

{% include prev_next.md %}
