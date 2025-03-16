# frozen_string_literal: true

require 'English'

# VimMarkdown is loaded into VIM when user opens a markdown file.
module VimMarkdown
  def self.after(directory)
    VIM.evaluate('b:VimMarkdownMetadataPlugins').split.each do |plugin|
      VimMarkdown.const_get(plugin.capitalize).send "after_#{directory}"
    rescue NameError
      # nevermind...
    end
  end

  def self.symval(strval) = [strval[0].to_sym, strval[1]]

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
