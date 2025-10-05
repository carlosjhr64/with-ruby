# frozen_string_literal: true

module VimMarkdown
  module Syntax
    def self.markdown_fold
      lnum = VIM.evaluate('v:lnum').to_i
      return '>3' if in_yaml_header?(lnum)

      line = VIM::Buffer.current[lnum]
      if line.match?(/^#+ /) && not_code_block?(lnum)
        return ">#{line.index(' ')}"
      end
      '='
    end

    def self.in_yaml_header?(lnum)
      buffer = VIM::Buffer.current
      return false unless buffer[1].match?(/^---(\s*#.*)?$/)

      stays_true = true
      1.upto(lnum) do |i|
        return false unless stays_true
        line = buffer[i].chomp
        stays_true = false if line.empty? ||
                              line.match?(/^\.\.\.(\s*#.*)?$/) ||
                              line.match?(/^---(\s*#.*)?$/)
      end
      true
    end

    def self.in_code_block?(lnum)
      buffer = VIM::Buffer.current
      in_code_block = false
      1.upto(lnum) do |i|
        line = buffer[i] || ''
        in_code_block = !in_code_block if line.match?(/^```/)
      end
      in_code_block
    end

    def self.not_code_block?(lnum) = !in_code_block?(lnum)

    def self.markdown_fold_text
      # Fold text for meta-data
      foldstart = VIM.evaluate('v:foldstart').to_i
      if foldstart == 1
        return '--- MetaData(zo/zc to view/close) '
      end
      # Text for headings... Same as tpope's.
      foldend = VIM.evaluate('v:foldend').to_i
      n = foldend - foldstart + 1
      heading = VIM::Buffer.current[foldstart].strip
      "#{heading} [#{n} lines]"
    end

    def self.after_syntax = VIM.command "
      function VimMarkdownFold()
        return rubyeval('VimMarkdown::Syntax.markdown_fold')
      endfunction
      function VimMarkdownFoldText()
        return rubyeval('VimMarkdown::Syntax.markdown_fold_text')
      endfunction
      setlocal foldmethod=expr
      setlocal foldexpr=VimMarkdownFold()
      setlocal foldtext=VimMarkdownFoldText()
    "
  end
end
