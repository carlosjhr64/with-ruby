# frozen_string_literal: true

require 'English'

# VimMarkdown is loaded into VIM when user opens a markdown file.
# It expects the file to maybe have a header setting the plugins list.
# Currently, the following plugins are supported:
# * Plugins: navigation fold
module VimMarkdown
  # VimMarkdown.enable is called in:
  # * after/ftplugin/markdown.vim as `ruby VimMarkdown.enable`
  def self.enable
    VIM.evaluate('b:VimMarkdownMetadataPlugins').split.each do |plugin|
      # With-Ruby includes the following:
      # * VimMarkdown::Fold.enable
      # * VimMarkdown::Navigation.enable
      VimMarkdown.const_get(plugin.capitalize).enable
    rescue
      print $ERROR_INFO
    end
  end

  # Expects [String, String] and returns [Symbol, String]
  def self.symval(strval) = [strval[0].to_sym, strval[1]]

  # Reads the markdown's metadata header and yields each key-value pair.
  def self.metadata_each(buffer = VIM::Buffer.current, line_number = 1)
    while (line = buffer[line_number]&.strip)
      case line
      when /^\w+:/ then yield symval line.split(':', 2).map(&:strip)
      when /^---/, /^\.\.\./
        break if line_number > 1
      else
        break
      end
      line_number += 1
    end
  end

  def self.metadata_set(key, value)
    VIM.command "let b:VimMarkdownMetadata#{key} = '#{value}'"
  end

  # Finds the metadata key in the current buffer and sets the value to
  # the buffer variable `b:VimMarkdownMetadata#{key}`.
  # Currently, just want to set `b:VimMarkdownMetadataPlugins` to the
  # plugins list, which is used by VimMarkdown.plugins to `require` each
  # plugin in the list.
  def self.metadata(key)
    metadata_each do |k, v|
      if key == k
        metadata_set(k, v)
        return
      end
    end
    metadata_set(key, '')
  end

  def self.plugins(plugins = VIM.evaluate('b:VimMarkdownMetadataPlugins'))
    plugins.to_s.split.each do |plugin|
      require "vim-markdown/#{plugin}"
    rescue LoadError
      print $ERROR_INFO
    end
  end
end
