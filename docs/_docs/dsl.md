---
title: CodePipeline DSL
nav_order: 8
---

CodePipeline provides a simple yet powerful DSL to create CodePipeline related resources.  Here are some examples of resources it can create:

* [pipeline]({% link _docs/dsl/pipeline.md %}): The CodePipeline pipeline. This is required.
* [iam role]({% link _docs/dsl/role.md %}): The IAM role associated with the CodePipeline pipeline.
* [webhook]({% link _docs/dsl/webhook.md %}): The webhook associated with the CodePipeline pipeline.
* [schedule]({% link _docs/dsl/schedule.md %}): An CloudWatch Event rule. The rule triggers the pipeline to start on a scheduled basis.

{% include prev_next.md %}