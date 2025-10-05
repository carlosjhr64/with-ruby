# VimMarkdown

* Reads markdown metadata key-value pairs as `let b:VimMarkdownMetadata#{key} = '#{value}'`.
* Sub-plugins activated based on metadata key `Plugins:`' value.

## Usage

`VimMarkdown` expects maybe a markdown metadata header like:
```markdown
---
Title:   The Title
Author:  John Doe
Plugins: navigation fold
---
```
The `Plugins:` metadata key should list the sub-plugins to be activated on the markdown file.
The following `VimMarkdown` plugins are available:

* [navigation](NAVIGATION.md)
* [fold](FOLD.md)

If not specified, `Plugins:` defaults to as set in `g:VimMarkdownMetadataPlugins`(or nothing).
```vim
let g:VimMarkdownMetadataPlugins = 'navigation'
```
More Vim-Ruby plugins can be added.
See [`markdown.rb`](lib/vim-markdown.rb?self.plugins) to see how `VimMarkdown` requires in the plugins.
