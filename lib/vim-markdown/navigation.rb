module VimMarkdown
module Navigation
  MARKDOWN_LINK = /\[[^\[\]]*\]\((?<link>[^\(\)]*)\)/
  HELP_TAG      = /(?<link>\|[^"*\|\s]+)\|/

  def self.anchor(heading)
    # Note that github uses '-' for spaces
    VIM.command "/^\\s*#\\+\\s*#{heading.gsub('-','\s')}"
    VIM.command "noh"
  end

  def self.search(string)
    VIM.command "/^[^?]*#{string}"
    VIM.command "noh"
  end

  def self.link_handler(link = nil)
    unless link
      row,column = VIM::Window.current.cursor
      line = VIM::Buffer.current[row]
      [MARKDOWN_LINK, HELP_TAG].each do |pattern|
        col = column
        if md = pattern.match(line)
          link,offset = md[:link],md.offset(0)[1]
          while col > offset and md = pattern.match(md.post_match)
            col -= offset
            link,offset = md[:link],md.offset(0)[1]
          end
        end
        break if link
      end
    end
    if link
      file, number, anchor, search = link, '1', nil, nil
      case link
      when /^#/
        Navigation.anchor link[1..-1]
        return
      when /^\?/
        Navigation.search link[1..-1]
        return
      when /^\|/
        VIM.command "help #{link[1..-1]}"
        return
      when /^https?:/
        spawn("xdg-open '#{link}'", out: '/dev/null', err: [:child, :out])
        return
      when /^([^#?]+)#L(\d+)$/
        file, number = $1, $2
      when /^([^?#]+)[#]([^?#]+)$/
        file, anchor = $1, $2
      when /^([^?#]+)[?]([^?#]+)$/
        file, search = $1, $2
      end
      unless file[0]=='/'
        dir = File.dirname Vim.evaluate('expand("%")') 
        file = File.expand_path File.join(dir, file)
      end
      file << '.md' unless /\.\w+$/.match?(file) or File.exist?(file)
      VIM.command "e +#{number} #{file}"
      if anchor
        Navigation.anchor anchor
      end
      if search
        Navigation.search search
      end
    else
      VIM.command %q{
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
    end
  end

  def self.after_ftplugin
    # vim mappings
    VIM.command "nnoremap <Backspace> <C-o>"
    VIM.command "nnoremap <CR> :ruby VimMarkdown::Navigation.link_handler<CR>"
  end
end
end
