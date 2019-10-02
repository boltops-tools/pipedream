---
title: Structure
nav_order: 4
---

The `pipe init` command generates the initial directory structure that looks like this:

    .pipedream
    ├── pipeline.rb
    ├── role.rb
    ├── schedule.rb
    ├── settings.yml
    └── webhook.rb

The table below states the purpose of each file:

File / Directory  | Description
------------- | -------------
pipeline.rb  | The pipeline defintion. More info: [Pipeline DSL]({% link _docs/dsl/pipeline.md %})
role.rb  | The IAM role defintion. More info: [Role DSL]({% link _docs/dsl/role.md %})
schedule.rb  | The schedule defintion. More info: [Schedule DSL]({% link _docs/dsl/schedule.md %})
settings.yml  | Settings for pipedream. More info: [Settings]({% link _docs/settings.md %})
webhook.rb  | The webhook defintion. More info: [Webhook DSL]({% link _docs/dsl/webhook.md %})

{% include prev_next.md %}
