# frozen_string_literal: true

module VimMarkdown
  # This module adds to the markdown syntax a fold for the metadata header when
  # the metadata start and end marker is set to `--- #` and `... #`. The hashtag
  # is used to disambiguate from the use of the horizontal rule in the markdown
  # syntax and is legal in the YAML spec. Furthermore, it marks intent by the
  # writer to fold the metadata section.
  # The module also sets the fold level(0) and the conceal level(2).
  module Syntax
    VIM_MARKDOWN_FOLD_TEXT = %q{
      function VimMarkdownFoldText()
        if (v:foldstart == 1)
          return "--- MetaData(zo/zc to view/close) "
        end
        let n = v:foldend - v:foldstart + 1
        return "--- " . n . " lines: "
      endfunction
      setlocal foldmethod=marker
      setlocal foldmarker=---\ #,...\ #
      setlocal foldlevel=0
      setlocal foldtext=VimMarkdownFoldText()
      setlocal conceallevel=2
    }

    def self.after_syntax = VIM.command VIM_MARKDOWN_FOLD_TEXT
  end
end
