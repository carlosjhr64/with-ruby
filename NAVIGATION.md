# VimMarkdown::Navigation

`Navigation` is a `VimMarkdown` sub-plugin activated when
the markdown's metadata key `Plugins:` contains the string `"navigation"`.
It automates markdown file navigation via the `<Enter>` and `<Back>` keys.
Supports:

+ Optional `.md` suffix: `[README](README)`
+ Anchors to headings: `[README.md#Installation](README.md#Installation)`
+ Line number: `[README.md#L50](README.md#L50)`
+ Search string: `[README.md?Copyright](README.md?Copyright)`
+ URL opened by linux's `xdg-open`: `[https://github.com/carlosjhr64/with-ruby](https://github.com/carlosjhr64/with-ruby)`
+ Help topic: `|WithRuby|`
+ Tag identifier or help topic on word under cursor, `<cword>`: `link_handler`
