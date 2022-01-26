set softtabstop=4
set shiftwidth=4
set expandtab
set number
set cursorline
hi cursorline cterm=none term=none
highlight CursorLine ctermbg=darkgrey
set cursorcolumn
set showcmd
set showmatch
set autoindent
set title
set pastetoggle=<F2>

" Search
set ic

" Highlight 80 character limit
"set colorcolumn=80
let &colorcolumn = join(range(81,999), ',')
highlight ColorColumn ctermbg=darkgrey

" Keep search results at the center of screen
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz
" Enable Highlight Search
set hlsearch
" Highlight while search
set incsearch

" Press <leader> Enter to remove search highlights
noremap <silent> <leader><CR> :noh<CR>

cnoremap <expr> <CR> getcmdtype() == '/' ? '<CR>zz' : '<CR>'
autocmd BufWritePre * :%s/\s\+$//e

set number
set relativenumber
filetype on
syntax on
