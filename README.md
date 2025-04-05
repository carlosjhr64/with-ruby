--- # Set your choice of plugins here.
Plugins: navigation syntax
... #

# WithRuby

* [VERSION 3.0.250317](https://github.com/carlosjhr64/with-ruby/releases)
* [github](https://github.com/carlosjhr64/with-ruby)

## Description:

`WithRuby` facilitates writing VIM plug-ins in ruby.
Uses the [neovim gem](https://github.com/neovim/neovim-ruby).

## Installation

* Required Ruby version: `>= 3.4`

### Via vim-plug

Using [vim-plug](https://github.com/junegunn/vim-plug),
add to your `~/.config/nvim/init.vim`:
```vim
" The following has my suggested vim-plug directory, but use yours:
call plug#begin('~/.local/share/nvim/site/pack/vim-plug')
" Maybe other people's plugs...
Plug 'carlosjhr64/with-ruby'
" and maybe other people's plugs...
call plug#end()
```
### Via git clone

Create a `site/pack/bundle/start` directory(or wherever you bundles are) and clone the git there:
```console
$ mkdir -p ~/.local/share/nvim/site/pack/bundle/start
$ cd ~/.local/share/nvim/site/pack/bundle/start
$ git clone https://github.com/carlosjhr64/with-ruby
```
See neovim's `:help packages` for more info.

## Features:

* Adds `with-ruby/lib` and `./lib` to ruby's load path.
* For help see |WithRuby|, `:help WithRuby`.
* Includes [`VimMarkdown`](VIM_MARKDOWN.md) for added features on `markdown` files.

## LICENSE:

(The MIT License)

Copyright (c) 2025 CarlosJHR64

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## [CREDITS](CREDITS.md)
