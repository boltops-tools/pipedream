Example:

    pipe completion

Prints words for TAB auto-completion.

Examples:

    pipe completion
    pipe completion hello
    pipe completion hello name

To enable, TAB auto-completion add the following to your profile:

    eval $(pipe completion_script)

Auto-completion example usage:

    pipe [TAB]
    pipe hello [TAB]
    pipe hello name [TAB]
    pipe hello name --[TAB]
