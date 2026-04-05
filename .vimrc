"===============================================================
" Description: Yet another custom ~/.vimrc
" Author:      https://github.com/pablon
"===============================================================

" Leader
nnoremap <SPACE> <Nop>
let mapleader = " "
let g:lasttab = 1

"===============================================================
" => Plugins (vim-plug) — https://github.com/junegunn/vim-plug
"===============================================================
call plug#begin('~/.vim/autoload/plugged')
  " Git
  Plug 'tpope/vim-fugitive' | Plug 'airblade/vim-gitgutter'
  " File explorer (lazy-loaded)
  Plug 'preservim/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind', 'NERDTreeFocus'] }
  Plug 'tpope/vim-vinegar'
  " Search / nav
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } | Plug 'junegunn/fzf.vim'
  Plug 'liuchengxu/vim-which-key'
  " Editing (tpope essentials)
  Plug 'tpope/vim-commentary' | Plug 'tpope/vim-surround' | Plug 'tpope/vim-unimpaired' | Plug 'tpope/vim-repeat'
  Plug 'junegunn/vim-easy-align', { 'on': '<Plug>(EasyAlign)' }
  Plug 'mg979/vim-visual-multi', { 'branch': 'master' }
  Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
  " UI
  Plug 'catppuccin/vim', { 'as': 'catppuccin' }
  Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes'
  Plug 'ryanoasis/vim-devicons'
  " LSP / completion
  Plug 'neoclide/coc.nvim', { 'branch': 'release' }
call plug#end()

"===============================================================
" => Options
"===============================================================
filetype plugin indent on | syntax enable
set nocompatible encoding=utf8 fileformats=unix,dos background=dark
set number relativenumber signcolumn=yes cursorline cursorcolumn colorcolumn=80
" clipboard: unnamed (macOS/X11 primary), unnamedplus (X11/Wayland clipboard)
set mouse=a clipboard=unnamed,unnamedplus title history=2000 path+=** hidden autoread
set splitbelow splitright switchbuf=useopen,usetab,newtab showtabline=2 laststatus=2 noshowmode ruler cmdheight=1
set scrolloff=7 sidescrolloff=8 whichwrap+=<,>,h,l backspace=eol,start,indent
set ignorecase smartcase incsearch hlsearch showmatch matchtime=2
set wildmenu wildmode=longest,list,full wildoptions=fuzzy
set wildignore=*.o,*~,*.pyc,*.swp,*.bak,*.class,*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
set autoindent expandtab smarttab linebreak nowrap textwidth=80
set tabstop=2 softtabstop=2 shiftwidth=2
set foldenable foldcolumn=1 foldmethod=manual foldlevelstart=10 foldnestmax=10
set nobackup nowritebackup noswapfile undofile undodir=~/.vim/undodir
set belloff=all timeoutlen=500 fillchars+=vert:\
set nrformats-=octal shortmess+=I
set list listchars=tab:│\ ,trail:·,extends:…,precedes:…,nbsp:␣
if !isdirectory(&undodir) | call mkdir(&undodir, 'p', 0700) | endif

" netrw (enhanced by vim-vinegar)
let g:netrw_banner=0 | let g:netrw_browse_split=4 | let g:netrw_altv=1 | let g:netrw_liststyle=3

" tmux cursor shape
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7" | let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" sudo save / tags
command! W w !sudo tee % > /dev/null
command! MakeTags !ctags -R .

"===============================================================
" => Autocmds
"===============================================================
augroup vimrc
  autocmd!
  autocmd FocusGained,BufEnter * checktime
  autocmd BufEnter * setlocal formatoptions-=r formatoptions-=o
  autocmd FileType vim setlocal foldmethod=marker
  autocmd FileType yaml,yml setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType python,go setlocal ts=4 sts=4 sw=4 expandtab
  autocmd FileType make setlocal ts=4 sts=4 sw=4 noexpandtab
  autocmd FileType markdown setlocal wrap linebreak textwidth=80
  autocmd TabLeave * let g:lasttab = tabpagenr()
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
  autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee call CleanExtraSpaces()
  autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
augroup END

function! CleanExtraSpaces()
  let s = getpos(".") | let q = getreg('/') | silent! %s/\s\+$//e
  call setpos('.', s) | call setreg('/', q)
endfunction

"===============================================================
" => Core mappings
"===============================================================
" Save / quit
nnoremap <leader>w :w!<cr>
nnoremap <leader>W :wall!<cr>
nnoremap <leader>qq :qall!<cr>
" NOTE: <C-S>/<C-Q> conflict with terminal XON/XOFF on Linux.
"       Add `stty -ixon` to ~/.bashrc or ~/.zshrc to enable these.
nnoremap <C-S> :w<CR>
nnoremap <C-Q> :q!<CR>

" Quick edits / scribble
nnoremap <leader>Q :e ~/buffer<cr>
nnoremap <leader>x :e ~/buffer.md<cr>
nnoremap <F2> :set paste!<CR>
nnoremap <F3> i<C-R>=strftime("\n# %Y-%m-%d %T \t\t")<CR>
inoremap <F3> <C-R>=strftime("\n# %Y-%m-%d %T \t\t")<CR>
nnoremap <F10> :set wrap!<CR>

" Window nav / resize
nnoremap <C-j> <C-W>j | nnoremap <C-k> <C-W>k | nnoremap <C-h> <C-W>h | nnoremap <C-l> <C-W>l
nnoremap <leader><left>  :vertical resize +20<cr>
nnoremap <leader><right> :vertical resize -20<cr>
nnoremap <leader><up>    :resize +10<cr>
nnoremap <leader><down>  :resize -10<cr>

" Buffers & tabs
nnoremap <leader>bd :bp\|bd #<cr>
nnoremap <leader>ba :bufdo bd<cr>
nnoremap <leader>l :bnext<cr>
nnoremap <leader>h :bprevious<cr>
nnoremap <leader>tn :tabnew<cr>
nnoremap <leader>to :tabonly<cr>
nnoremap <leader>tc :tabclose<cr>
nnoremap <leader>tm :tabmove 
nnoremap <leader>tl :exe "tabn ".g:lasttab<CR>
nnoremap <leader>te :tabedit <C-r>=expand("%:p:h")<cr>/

" Misc
nnoremap 0 ^
nnoremap gV `[v`]
nnoremap <silent> <leader><cr> :noh<cr>
nnoremap <leader>cd :cd %:p:h<cr>:pwd<cr>

" Move lines with Alt+[jk]
nnoremap <M-j> mz:m+<cr>`z
nnoremap <M-k> mz:m-2<cr>`z
vnoremap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vnoremap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

" Visual-mode search for selection
vnoremap <silent> * y/\V<C-R>=escape(@",'/\')<CR><CR>
vnoremap <silent> # y?\V<C-R>=escape(@",'?\')<CR><CR>

" Spell
nnoremap <leader>ss :setlocal spell!<cr>
nnoremap <leader>sn ]s | nnoremap <leader>sp [s | nnoremap <leader>sa zg | nnoremap <leader>s? z=

"===============================================================
" => Nvim-parity mappings (muscle-memory across editors)
"===============================================================
" Center-scroll (Nvim behavior: keep cursor centered)
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap n nzzzv
nnoremap N Nzzzv

" Quality-of-life (modern Nvim idioms)
nnoremap Y y$
nnoremap J mzJ`z
nnoremap <CR> za

" Keep selection when indenting
vnoremap < <gv
vnoremap > >gv

" LSP via coc.nvim (matches Nvim's built-in LSP keymaps)
nmap <silent> K <Plug>(coc-hover)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nnoremap <silent> <leader>ca :call CocActionAsync('codeAction')<cr>
nmap <silent> <leader>rn <Plug>(coc-rename)
nnoremap <silent> <leader>p :CocEnable<cr>
nnoremap <silent> <leader>P :CocDisable<cr>
nnoremap <silent> <leader>S :CocDisable<cr>

" LSP diagnostic navigation (Nvim parity: ]d / [d)
nmap <silent> ]d <Plug>(coc-diagnostic-next)
nmap <silent> [d <Plug>(coc-diagnostic-prev)

" Git hunk navigation (matches Nvim gitsigns: [h/]h, [H/]H)
nmap <silent> ]h <Plug>(GitGutterNextHunk)
nmap <silent> [h <Plug>(GitGutterPrevHunk)
nnoremap <silent> ]H :GitGutterNextHunk<cr>:GitGutterNextHunk<cr>
nnoremap <silent> [H :GitGutterPrevHunk<cr>:GitGutterPrevHunk<cr>

" Align / surround (Nvim: <leader>al, <leader>aq, <leader>ws)
nmap <leader>al <Plug>(EasyAlign)
xmap <leader>al <Plug>(EasyAlign)
nmap <leader>aq ysiw"
nmap <leader>ws ysiw

" Fzf finders (Nvim: <leader>ff/fb/fg/fs via Snacks/Telescope)
nnoremap <leader>ff :Files<cr>
nnoremap <leader>fb :Buffers<cr>
nnoremap <leader>fg :Rg<cr>
nnoremap <silent> <leader>fs :call CocActionAsync('documentSymbols')<cr>
nnoremap <leader>tgb :Git branch<cr>
nnoremap <leader>tgc :Git log --oneline --decorate --graph<cr>

" Undotree (Nvim: <leader>U)
nnoremap <leader>U :UndotreeToggle<cr>

"===============================================================
" => FZF colors
"===============================================================
let g:fzf_colors = {
  \ 'fg': ['fg','Normal'], 'bg': ['bg','Normal'], 'preview-bg': ['bg','NormalFloat'],
  \ 'hl': ['fg','Comment'], 'fg+': ['fg','CursorLine','CursorColumn','Normal'],
  \ 'bg+': ['bg','CursorLine','CursorColumn'], 'hl+': ['fg','Statement'],
  \ 'info': ['fg','PreProc'], 'border': ['fg','Ignore'], 'prompt': ['fg','Conditional'],
  \ 'pointer': ['fg','Exception'], 'marker': ['fg','Keyword'],
  \ 'spinner': ['fg','Label'], 'header': ['fg','Comment'] }
" (fzf rtp auto-added by junegunn/fzf plugin via plug#install)

" Trailing whitespace match (highlight styled in vimrc_highlights)
highlight default ExtraWhiteSpace ctermbg=red guibg=red
match ExtraWhiteSpace /\s\+$/

"===============================================================
" => Theme + Highlights (applied after colorscheme)
"===============================================================
colorscheme catppuccin_mocha

augroup vimrc_highlights
  autocmd!
  autocmd ColorScheme * hi CursorLine cterm=BOLD ctermbg=Black guibg=Black
  autocmd ColorScheme * hi CursorColumn cterm=BOLD ctermbg=Black guibg=Black
  autocmd ColorScheme * hi Comment cterm=italic ctermfg=DarkGray
  autocmd ColorScheme * hi LineNr term=bold ctermbg=none ctermfg=none gui=bold
  autocmd ColorScheme * hi CursorLineNr term=bold ctermbg=none ctermfg=yellow gui=bold
  autocmd ColorScheme * hi SignColumn ctermbg=Black guibg=Black
  autocmd ColorScheme * hi ColorColumn ctermbg=0 guibg=darkgrey
  autocmd ColorScheme * hi ExtraWhiteSpace ctermbg=red guibg=red
  autocmd ColorScheme * hi GitGutterAdd    guifg=#009900 ctermfg=2
  autocmd ColorScheme * hi GitGutterChange guifg=#bbbb00 ctermfg=3
  autocmd ColorScheme * hi GitGutterDelete guifg=#ff2222 ctermfg=1
  " Which-Key popup (catppuccin-mocha palette)
  autocmd ColorScheme * hi WhichKeyFloating  guibg=#181825 guifg=#cdd6f4 ctermbg=234 ctermfg=255
  autocmd ColorScheme * hi NormalFloat       guibg=#181825 guifg=#cdd6f4 ctermbg=234 ctermfg=255
  autocmd ColorScheme * hi FloatBorder       guibg=#181825 guifg=#585b70 ctermbg=234 ctermfg=242
  autocmd ColorScheme * hi WhichKey          guifg=#89b4fa guibg=NONE ctermfg=111 cterm=bold gui=bold
  autocmd ColorScheme * hi WhichKeySeperator guifg=#585b70 guibg=NONE ctermfg=242
  autocmd ColorScheme * hi WhichKeyGroup     guifg=#fab387 guibg=NONE ctermfg=216 cterm=bold gui=bold
  autocmd ColorScheme * hi WhichKeyDesc      guifg=#a6adc8 guibg=NONE ctermfg=248
augroup END
doautocmd vimrc_highlights ColorScheme

"===============================================================
" => Airline
"===============================================================
let g:airline_theme = 'catppuccin_mocha'
let g:airline_powerline_fonts = 1
let g:airline_skip_empty_sections = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#hunks#enabled = 1
let g:airline#extensions#whitespace#enabled = 1
let g:airline#extensions#coc#enabled = 1
if !exists('g:airline_symbols') | let g:airline_symbols = {} | endif
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = '☰'
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.dirty = ' ⚡'
let g:airline_section_z = airline#section#create(['%l:%c  %p%%'])

"===============================================================
" => Plugin Configs
"===============================================================
" gitgutter
let g:gitgutter_set_sign_backgrounds = 1
let g:gitgutter_highlight_linenrs = 1
let g:gitgutter_preview_win_floating = 1

" NERDTree
let g:NERDTreeFileLines = 1 | let g:NERDTreeWinSize = 40 | let g:NERDTreeShowHidden = 1
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

"===============================================================
" => Which-Key (Nvim-style floating popup)
"===============================================================
let g:which_key_use_floating_win = 1
let g:which_key_floating_relative_win = 1
let g:which_key_floating_opts = { 'row': '-1', 'col': '+0' }
let g:which_key_centered = 1
let g:which_key_sep = '→'
let g:which_key_hspace = 5
let g:which_key_display_names = { '<CR>': '↵', '<Tab>': '⇆', '<Space>': 'SPC' }
" CRITICAL: prevent infinite-loop freeze on undefined keys (PR #232 bug)
let g:which_key_fallback_to_native_key = 1
let g:which_key_ignore_invalid_key = 0

nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :<c-u>WhichKeyVisual '<Space>'<CR>

" ── Descriptions dictionary ──
let g:which_key_map = {
  \ 'w':  'save',
  \ 'W':  'save-all',
  \ 'Q':  'scribble',
  \ 'x':  'scribble-md',
  \ 'l':  'next-buffer',
  \ 'h':  'prev-buffer',
  \ 'cd': 'cd-to-buffer-dir',
  \ 'p':  'enable-completion',
  \ 'P':  'disable-completion',
  \ 'S':  'stop-lsp',
  \ 'U':  'undotree-toggle',
  \ '<CR>':    'clear-highlight',
  \ '<Left>':  'vsplit-grow',
  \ '<Right>': 'vsplit-shrink',
  \ '<Up>':    'hsplit-grow',
  \ '<Down>':  'hsplit-shrink',
  \ }

let g:which_key_map.a = { 'name':'+align/surround', 'l':'easy-align', 'q':'add-quotes' }
let g:which_key_map.b = { 'name':'+buffer', 'd':'delete', 'a':'close-all' }
let g:which_key_map.c = { 'name':'+code', 'a':'code-action' }
let g:which_key_map.e = { 'name':'+explorer', 'f':'find-file', 't':'toggle', 'o':'focus' }
let g:which_key_map.f = { 'name':'+find', 'f':'files', 'b':'buffers', 'g':'grep', 's':'symbols' }
let g:which_key_map.g = { 'name':'+git', 'd':'diff', 's':'status', 'b':'blame', 'c':'commit', 'l':'log', 'p':'push' }
let g:which_key_map.q = { 'name':'+quit', 'q':'quit-all' }
let g:which_key_map.r = { 'name':'+refactor', 'n':'rename' }
let g:which_key_map.s = { 'name':'+spell', 's':'toggle', 'n':'next-error', 'p':'prev-error', 'a':'add-to-dict', '?':'suggest' }
let g:which_key_map.t = { 'name':'+tab', 'n':'new', 'o':'only', 'c':'close', 'm':'move', 'l':'last-used', 'e':'edit-in-dir', 'gb':'git-branches', 'gc':'git-commits' }
let g:which_key_map.w = { 'name':'+word/save', 's':'word-surround' }

call which_key#register('<Space>', 'g:which_key_map')

" +git group mappings (fugitive)
nnoremap <leader>gd :Git diff<CR>
nnoremap <leader>gs :Git<CR>
nnoremap <leader>gb :Git blame<CR>
nnoremap <leader>gc :Git commit<CR>
nnoremap <leader>gl :Git log --oneline --decorate --graph<CR>
nnoremap <leader>gp :Git push<CR>

" +explorer group mappings
nnoremap <leader>ef :NERDTreeFind<CR>
nnoremap <leader>et :NERDTreeToggle<CR>
nnoremap <leader>eo :NERDTreeFocus<CR>
