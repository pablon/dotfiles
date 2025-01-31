"===============================================================
" Description: Yet another custom ~/.vimrc
" Author:      https://github.com/pablon
"===============================================================
" Refs:
"   https://vim.fandom.com/wiki/Vim_documentation
"   https://github.com/amix/vimrc
"   https://dougblack.io/words/a-good-vimrc.html
"   https://vimawesome.com/
"   https://codingpotions.com/vim-configuracion/  (spanish)
"   https://github.com/altermo/vim-plugin-list
"   https://github.com/junegunn/vim-plug
"===============================================================

"===============================================================
" => General
"===============================================================

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
" let mapleader = " "
let mapleader = "\<Space>"

" Fast saving
nmap <leader>w :w!<cr>
nmap <leader>W :wall!<cr>
" Fast quit
nmap <leader>q :q!<cr>
nmap <leader>Q :qall!<cr>
" :W sudo saves the file
" (useful for handling the permission-denied error)
command! W w !sudo tee % > /dev/null " :W sudo saves the file when the file is open in readonly mode
" basic stuff
set clipboard=unnamed       " will make Vim yank to the clipboard
set fillchars+=vert:\       " Remove unpleasant pipes from vertical splits
set history=2000            " sets how many lines of history VIM has to remember
set nocompatible            " yup
set number                  " show line numbers
set path+=**                " recurse into dirs
set relativenumber          " show relative line numbers
set showcmd                 " show command in bottom bar
set signcolumn=yes          " draw the signcolumn
set title                   " change the terminal's title
filetype plugin indent on   " Enable filetype plugins
let &t_ut=''                " To render properly background of the color scheme
" Create the `tags` file (may need to install ctags first)
command! MakeTags !ctags -R .
" Tweaks for browsing
let g:netrw_banner=0        " disable annoying banner
let g:netrw_browse_split=4  " open in prior window
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3     " tree view
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'
" Splitting
set splitbelow
set splitright
" Set to auto read when a file is changed from the outside
set autoread
au FocusGained,BufEnter * checktime
"folding stuff
set foldcolumn=1                    " Add a bit extra margin to the left
set foldenable                      " enable folding
set foldmethod=manual               " fold method
set foldlevelstart=10               " open most folds by default
set foldnestmax=10                  " 10 nested fold max
" space open/closes folds
nnoremap <space> za

augroup filetype_vim
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
augroup END

" highlight last inserted text
nnoremap gV `[v`]
if exists('$TMUX')                  " allows cursor change in tmux mode
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

"===============================================================
" => Custom mappings
"===============================================================
" <F2> toggles paste mode on and off
function! TogglePaste()
  if (&paste == 1)
    set nopaste
  else
    set paste
  endif
endfunction

" <F2> toggles paste mode
map <F2> :call TogglePaste()<CR> " paste
map! <F2> ^[:call TogglePaste()<CR> " nopaste

" <F3> prints current timestamp as a comment (for quick notes)
nmap <F3> i<C-R>=strftime("\n# %Y-%m-%d %T \t\t")<CR>
imap <F3> <C-R>=strftime("\n# %Y-%m-%d %T \t\t")<CR>

" <F10> toggles wrap on/off
function! ToggleWrap()
  if (&wrap == 1)
    set nowrap
  else
    set wrap
  endif
endfunction
map <F10> :call ToggleWrap()<CR> " wrap
map! <F10> ^[:call ToggleWrap()<CR> " un-wrap

function GitDiff()
    :silent write
    :silent execute '!git diff --color=always -- ' . expand('%:p') . ' | less --RAW-CONTROL-CHARS --quit-if-one-screen --mouse'
    :redraw!
endfunction
nnoremap <leader>gd :call GitDiff()<cr>

nmap <C-S> :w<CR>   " quick save
nmap <C-Q> :q!<CR>  " quit now

"===============================================================
" => VIM user interface
"===============================================================
" Set 7 lines to the cursor - when moving vertically using j/k (scrolloff)
set scrolloff=7
" Avoid garbled characters in Chinese language windows OS
let $LANG='en'
set langmenu=en
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim
" Turn on the Wild menu
set wildmenu
set wildmode=longest,list,full
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx,*.tar,*.gz,*.zip,*.bz2

set wildoptions=fuzzy
" Ignore compiled files
set wildignore=*.o,*~,*.pyc,*.swp,*.bak,*.pyc,*.class
if has("win16") || has("win32")
  set wildignore+=.git\*,.hg\*,.svn\*
else
  set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif
set backspace=eol,start,indent " Configure backspace so it acts as it should act
set cmdheight=1                " Height of the command bar
set hid                        " A buffer becomes hidden when it is abandoned
set hlsearch                   " Highlight search results
set ignorecase                 " Ignore case when searching
set incsearch                  " Makes search act like search in modern browsers
set lazyredraw                 " Don't redraw while executing macros (good performance config)
set magic                      " For regular expressions turn magic on
set mat=2                      " How many tenths of a second to blink when matching brackets
set noerrorbells               " Disable beep or screen flash
set novisualbell               " Disable visual bell
set ruler                      " Always show current position
set showmatch                  " Show matching brackets when text indicator is over them
set smartcase                  " When searching try to be smart about cases
set timeoutlen=500             " Time in milliseconds to wait for a mapped sequence to complete.
set ttyfast                    " Indicates a fast terminal connection.
set whichwrap+=<,>,h,l         " Allow specified keys that move the cursor left/right

" Properly disable sound on errors on MacVim
if has("gui_macvim")
  autocmd GUIEnter * set vb t_vb=
endif

"===============================================================
" => Colors and Fonts
"===============================================================
" Enable syntax highlighting
syntax enable

" Enable 256 colors palette in Gnome Terminal
if $COLORTERM == 'gnome-terminal'
  set t_Co=256
endif

try
  " To see a list of ready-to-use themes: :colorscheme [space] [Ctrl+d]
  colorscheme catppuccin_mocha
catch
endtry

set background=dark                 " my eyes say thank you
set cursorline cursorcolumn         " highlight current line & column
" highlights
hi CursorLine cterm=BOLD ctermbg=Black guibg=Black
hi CursorColumn cterm=BOLD ctermbg=Black guibg=Black
hi Comment cterm=italic ctermfg=DarkGray
hi lineNr term=bold cterm=NONE ctermbg=none ctermfg=none gui=bold
hi CursorLineNr term=bold cterm=none ctermbg=none ctermfg=yellow gui=bold
hi SignColumn ctermbg=Black guibg=Black

" Set extra options when running in GUI mode
if has("gui_running")
  set guioptions-=T
  set guioptions-=e
  set t_Co=256
  set guitablabel=%M\ %t
endif

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos

"===============================================================
" => Files, backups and undo
"===============================================================
" Turn backup off, since most stuff is in git, etc. anyway...
set nobackup
set nowritebackup
set noswapfile

"===============================================================
" => Text, tab and indent related
"===============================================================
set autoindent
set expandtab
set linebreak
set nowrap
set smartindent
set smarttab
set tabstop=2 softtabstop=2 shiftwidth=2 " use 2 spaces for tabs
set textwidth=500

""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

"===============================================================
" => Moving around, tabs, windows and buffers
"===============================================================
" Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
" map <space> /
map <C-space> ?

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Resize windows
map <leader><left> :vertical resize +20<cr>
map <leader><right> :vertical resize -20<cr>
map <leader><up> :resize +10<cr>
map <leader><down> :resize -10<cr>

" Close the current buffer
map <leader>bd :Bclose<cr>:tabclose<cr>gT

" Close all the buffers
map <leader>ba :bufdo bd<cr>
map <leader>l :bnext<cr>
map <leader>h :bprevious<cr>

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove
map <leader>t<leader> :tabnext

" Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <C-r>=expand("%:p:h")<cr>/

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

""""""""""""""""""""""""""""""
" => Status line
""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2
set noshowmode

" Format the status line
set statusline=
set statusline+=%7*\[%n]                                  "buffernr
set statusline+=%1*\ %<%F\                                "File+path
set statusline+=%2*\ %y\                                  "FileType
set statusline+=%3*\ %{''.(&fenc!=''?&fenc:&enc).''}      "Encoding
set statusline+=%3*\ %{(&bomb?\",BOM\":\"\")}\            "Encoding2
set statusline+=%4*\ %{&ff}\                              "FileFormat (dos/unix..)
set statusline+=%5*\ %{&spelllang}\%{HighlightSearch()}\  "Spellanguage & Highlight on?
set statusline+=%8*\ %=\ row:%l/%L\ (%03p%%)\             "Rownumber/total (%)
set statusline+=%9*\ col:%03c\                            "Colnr
set statusline+=%0*\ \ %m%r%w\ %P\ \                      "Modified? Readonly? Top/bot.

" http://vimdoc.sourceforge.net/htmldoc/syntax.html#hl-StatusLine
" now set it up to change the status color based on mode
if version >= 700
  au InsertEnter * hi StatusLine term=reverse ctermfg=5 ctermbg=15 gui=undercurl guisp=Magenta
  au InsertLeave * hi StatusLine term=reverse ctermfg=2 ctermbg=15 gui=bold,reverse
endif

function! HighlightSearch()
  if &hls
    return 'H'
  else
    return ''
  endif
endfunction

"===============================================================
" => Editing mappings
"===============================================================
" Remap VIM 0 to first non-blank character
map 0 ^

" Move a line of text using ALT+[jk] or Command+[jk] on mac
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

if has("mac") || has("macunix")
  nmap <D-j> <M-j>
  nmap <D-k> <M-k>
  vmap <D-j> <M-j>
  vmap <D-k> <M-k>
endif

" Delete trailing white space on save, useful for some filetypes ;)
fun! CleanExtraSpaces()
  let save_cursor = getpos(".")
  let old_query = getreg('/')
  silent! %s/\s\+$//e
  call setpos('.', save_cursor)
  call setreg('/', old_query)
endfun

if has("autocmd")
  autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee :call CleanExtraSpaces()
endif

"===============================================================
" => Spell checking
"===============================================================
" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

" Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=

"===============================================================
" => Misc
"===============================================================
" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Quickly open a buffer for scribble
map <leader>q :e ~/buffer<cr>

" Quickly open a markdown buffer for scribble
map <leader>x :e ~/buffer.md<cr>

"===============================================================
" => Helper functions
"===============================================================
" Returns true if paste mode is enabled
function! HasPaste()
  if &paste
    return 'PASTE MODE '
  endif
  return ''
endfunction

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
  let l:currentBufNum = bufnr("%")
  let l:alternateBufNum = bufnr("#")

  if buflisted(l:alternateBufNum)
    buffer #
  else
    bnext
  endif

  if bufnr("%") == l:currentBufNum
    new
  endif

  if buflisted(l:currentBufNum)
    execute("bdelete! ".l:currentBufNum)
  endif
endfunction

function! CmdLine(str)
  call feedkeys(":" . a:str)
endfunction

function! VisualSelection(direction, extra_filter) range
  let l:saved_reg = @"
  execute "normal! vgvy"

  let l:pattern = escape(@", "\\/.*'$^~[]")
  let l:pattern = substitute(l:pattern, "\n$", "", "")

  if a:direction == 'gv'
    call CmdLine("Ack '" . l:pattern . "' " )
  elseif a:direction == 'replace'
    call CmdLine("%s" . '/'. l:pattern . '/')
  endif

  let @/ = l:pattern
  let @" = l:saved_reg
endfunction

let g:fzf_colors =
\ { 'fg':         ['fg', 'Normal'],
  \ 'bg':         ['bg', 'Normal'],
  \ 'preview-bg': ['bg', 'NormalFloat'],
  \ 'hl':         ['fg', 'Comment'],
  \ 'fg+':        ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':        ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':        ['fg', 'Statement'],
  \ 'info':       ['fg', 'PreProc'],
  \ 'border':     ['fg', 'Ignore'],
  \ 'prompt':     ['fg', 'Conditional'],
  \ 'pointer':    ['fg', 'Exception'],
  \ 'marker':     ['fg', 'Keyword'],
  \ 'spinner':    ['fg', 'Label'],
  \ 'header':     ['fg', 'Comment'] }

" fzf
set rtp+=/usr/local/opt/fzf
" highlight trailing spaces
highlight ExtraWhiteSpace ctermbg=red guibg=red
match ExtraWhiteSpace /\s\+$/

"===============================================================
" => Plugins
" https://github.com/junegunn/vim-plug
" => Prep-work:
" mkdir -p ~/.vim/autoload/plugged
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"===============================================================

call plug#begin('~/.vim/autoload/plugged')
  Plug 'Xuyuanp/nerdtree-git-plugin'
  Plug 'airblade/vim-gitgutter'
  Plug 'camspiers/animate.vim'
  Plug 'camspiers/lens.vim'
  Plug 'catppuccin/vim', { 'as': 'catppuccin' }
  Plug 'chentoast/marks.nvim'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/vim-easy-align'
  Plug 'mg979/vim-visual-multi', {'branch': 'master'}
  Plug 'mhinz/vim-startify'
  Plug 'nathanaelkane/vim-indent-guides'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'preservim/nerdtree'
  Plug 'ryanoasis/vim-devicons'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-fugitive'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
call plug#end()

"===============================================================
" Airline
"===============================================================
let g:airline_theme = 'catppuccin_mocha'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#left_sep = ' '

"===============================================================
" gitgutter
"===============================================================
let g:gitgutter_set_sign_backgrounds = 1
let g:gitgutter_highlight_linenrs = 1
let g:gitgutter_preview_win_floating = 1
hi GitGutterAdd guifg=#009900 ctermfg=2
hi GitGutterChange guifg=#bbbb00 ctermfg=3
hi GitGutterDelete guifg=#ff2222 ctermfg=1

"===============================================================
" EasyAlign behavior
"===============================================================
" Start interactive EasyAlign in visual mode (e.g. vipal)
xmap al <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. alip)
nmap al <Plug>(EasyAlign)

"===============================================================
" NERDTree behavior
" https://github.com/preservim/nerdtree#frequently-asked-questions
"===============================================================

" Options:
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>
let g:NERDTreeFileLines = 1
let g:NERDTreeWinSize=40
let g:NERDTreeShowHidden=1
map <Leader>f :NERDTreeFind<CR>
let g:indent_guides_guide_size = 1
let g:indent_guides_enable_on_vim_startup = 0
" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
