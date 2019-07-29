---
title: pipe completion
reference: true
---

## Usage

    pipe completion *PARAMS

## Description

Prints words for auto-completion.

Example:

    codepipe completion

Prints words for TAB auto-completion.

Examples:

    codepipe completion
    codepipe completion hello
    codepipe completion hello name

To enable, TAB auto-completion add the following to your profile:

    eval $(codepipe completion_script)

Auto-completion example usage:

    codepipe [TAB]
    codepipe hello [TAB]
    codepipe hello name [TAB]
    codepipe hello name --[TAB]


## Options

```
[--verbose], [--no-verbose]  
[--noop], [--no-noop]        
```

