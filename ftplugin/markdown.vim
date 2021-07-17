" Loads in metadata requested plugins.
ruby require 'vim-markdown'
ruby VimMarkdown.metadata(:Plugins)
if !exists('g:VimMarkdownMetadataPlugins')
	let g:VimMarkdownMetadataPlugins = ''
endif
if b:VimMarkdownMetadataPlugins == ''
	let b:VimMarkdownMetadataPlugins = g:VimMarkdownMetadataPlugins
endif
ruby VimMarkdown.plugins
