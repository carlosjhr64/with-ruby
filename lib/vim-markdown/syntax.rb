module VimMarkdown
module Syntax
  def self.after_syntax
    VIM.command %q{
      function VimMarkdownFoldText()
        if (v:foldstart == 1) && (getline(1) =~ '\_^---')
          return "--- MetaData(zo/zc to view/close) "
        end
        let n = v:foldend - v:foldstart + 1
        return "+-- ".n." lines: "
      endfunction
      syn region vimMarkdownMetaDataFold start="\%^---" end="---" keepend transparent fold
      setlocal foldmethod=syntax
      setlocal foldtext=VimMarkdownFoldText()
      setlocal conceallevel=2
    }
  end
end
end
