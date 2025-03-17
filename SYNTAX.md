# VimMarkdown::Syntax

Syntax is a VimMarkdown sub-plugin activated when
the markdown's metadata key `Plugins:` contains the string `"syntax"`.
It adds the following feature:

* Folds the markdown's metadata header
* Sets markdown's syntax conceal(level=2)

The fold is by "--- #" and "... #" markers.
The hashtag is legal YAML for comments(see README's metadata header).

--- #
You can use these markers anywhere in the markdown for folding, but
only the header section is used for metadata.
The hashtag is used to disambiguate from markdown's horizontal rule.
... #

