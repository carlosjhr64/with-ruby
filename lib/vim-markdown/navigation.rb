# frozen_string_literal: true

require 'uri'

module VimMarkdown
  # This module provides a way to navigate links in markdown files.
  # When the user presses <CR>, the most apropriate action is taken based on the
  # the context the cursor is in. Precedence is as follows:
  # * A markdown link: [text](url)
  # * A help tag: |tag|
  # * A bare link: http://example.com
  # * A cword tag
  # * A cword help
  # See [NAVIGATION.md](../../NAVIGATION) for examples of each link type.
  module Navigation
    def self.enable
      # vim mappings
      VIM.command 'nnoremap <Backspace> <C-o>'
      VIM.command 'nnoremap <CR> :ruby VimMarkdown::Navigation.link_handler<CR>'
    end

    MARKDOWN_LINK = /\[[^\[\]]*\]\((?<link>[^()]*)\)/
    HELP_TAG = /(?<link>\|[^"*|\s]+)\|/
    begin
      BARE_LINK = URI::RFC2396_PARSER.make_regexp(%w[http https])
    rescue StandardError
      # rubocop:disable Lint/UriRegexp
      BARE_LINK = URI.regexp(%w[http https]) # Fallback for older Ruby
      # rubocop:enable Lint/UriRegexp
    end
    TAG_OR_HELP   = %q{
      let cword = expand('<cword>')
      try
        execute 'tag '.cword
      catch
        try
          execute 'help '.cword
        catch
          echo 'Nothing linked to "'.cword.'".'
        endtry
      endtry
    }

    def self.anchor_command(heading)
      # Note that github uses '-' for spaces
      VIM.command "/^\\s*#\\+\\s*#{heading.gsub('-', '\s')}"
      VIM.command 'noh'
    end

    def self.search_command(string)
      VIM.command "/^[^?]*#{string}"
      VIM.command 'noh'
    end

    # It's just a long list of different cases!
    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/CyclomaticComplexity
    def self.link_cases(link)
      file = link
      number = '1'
      anchor = nil
      search = nil
      case link
      when /^#/
        anchor_command link[1..]
        return
      when /^\?/
        search_command link[1..]
        return
      when /^\|/
        VIM.command "help #{link[1..]}"
        return
      when /^https?:/
        spawn("xdg-open '#{link}'", out: '/dev/null', err: %i[child out])
        return
      when /^([^#?]+)#L(\d+)$/
        file = ::Regexp.last_match(1)
        number = ::Regexp.last_match(2)
      when /^([^?#]+)#([^?#]+)$/
        file = ::Regexp.last_match(1)
        anchor = ::Regexp.last_match(2)
      when /^([^?#]+)[?]([^?#]+)$/
        file = ::Regexp.last_match(1)
        search = ::Regexp.last_match(2)
      end
      unless file[0] == '/'
        dir = File.dirname Vim.evaluate('expand("%")')
        file = File.expand_path File.join(dir, file)
      end
      file << '.md' unless /\.\w+$/.match?(file) || File.exist?(file)
      VIM.command "e +#{number} #{file}"
      anchor_command anchor if anchor
      search_command search if search
    end
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/CyclomaticComplexity

    def self.link_handler
      (link = link_get) ? link_cases(link) : VIM.command(TAG_OR_HELP)
    end

    def self.link_get
      row, column = VIM::Window.current.cursor
      line = VIM::Buffer.current[row]
      [MARKDOWN_LINK, HELP_TAG, BARE_LINK].each do |pattern|
        link = match_link(column, line, pattern) and return link
      end
      nil
    end

    def self.link_offset(mdt)
      [mdt[:link], mdt.offset(0)[1]]
    rescue StandardError
      [mdt[0], mdt.offset(0)[1]]
    end

    def self.match_link(col, line, pattern)
      link = nil
      if (md = pattern.match(line)) # See if the current line matches.
        link, offset = link_offset(md)
        # Accept the last match that does not occur past the cursor:
        while (col > offset) && (md = pattern.match(md.post_match))
          col -= offset
          link, offset = link_offset(md)
        end
      end
      link
    end
  end
end
