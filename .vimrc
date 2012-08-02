" -----------------------------------------------------------------------------
" |                            VIM Settings                                   |
" | Some highlights:                                                          |
" |   jj     = <esc>  Very useful for keeping your hands on the home row          |
" |   , /    = toggle highlight search |
" |   F2     = toggle line number and folding  |
" |   F3     = toggle spell check and invisible charaters |
" |   ctrl-e = toggle NERDTree off and on                                    |
" |   , nt   = NERDTree find ?
" |   , t   = CommandT file window |
" -----------------------------------------------------------------------------
"
" Environment {
    " Basics {
        set nocompatible        " must be first line
        set background=dark     " Assume a dark background
    " }

    " Windows Compatible {
        " On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
        " across (heterogeneous) systems easier.
        if has('win32') || has('win64')
          set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
        endif
    " }
    "
    " Setup Bundle Support {
        " The next two lines ensure that the ~/.vim/bundle/ system works
        runtime! bundle/vim-pathogen/autoload/pathogen.vim
        silent! call pathogen#infect()
        silent! call pathogen#helptags()
    " }

" }

" General {
    if !has('win32') && !has('win64')
        set term=$TERM       " Make arrow and other keys work
    endif
    filetype plugin indent on      " Automatically detect file types.
    syntax on                     " syntax highlighting
    set mouse=a                    " automatically enable mouse usage
    "set autochdir                 " always switch to the current file directory.. Messes with some plugins, best left commented out
    " not every vim is compiled with this, use the following line instead
    " If you use command-t plugin, it conflicts with this, comment it out.
     "autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif
    scriptencoding utf-8

    " set autowrite                  " automatically write a file when leaving a modified buffer
    set shortmess+=filmnrxoOtT         " abbrev. of messages (avoids 'hit enter')
    set viewoptions=folds,options,cursor,unix,slash " better unix / windows compatibility
    set virtualedit=onemore            " allow for cursor beyond last character
    set history=1000                  " Store a ton of history (default is 20)
    set spell                          " spell checking on

    " Setting up the directories {
        set nobackup         " backups is less useful as anything non-trivial is in git.
        set nowritebackup
        set noswapfile
        au BufWinLeave * silent! mkview  "make vim save view (state) (folds, cursor, etc)
        au BufWinEnter * silent! loadview "make vim load view (state) (folds, cursor, etc)
    " }
" }

" Vim UI {
    color ir_black                                         " load a colorscheme
    set tabpagemax=15                                      " only show 15 tabs
    set showmode                                           " display the current mode

    set cursorline                                         " highlight current line
    hi cursorline guibg=#333333                            " highlight bg color of current line
    hi CursorColumn guibg=#333333                          " highlight cursor

    if has('cmdline_info')
        set ruler                                          " show the ruler
        set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " a ruler on steroids
        set showcmd                                        " show partial commands in status line and
                                                           " selected characters/lines in visual mode
    endif

    if has('statusline')
        set laststatus=2

                                                           " Broken down into easily includeable segments
        set statusline=%<%f\                               " Filename
        set statusline+=%w%h%m%r                           " Options
        set statusline+=%{fugitive#statusline()}           " Git Hotness
        set statusline+=\ [%{&ff}/%Y]                      " filetype
        set statusline+=\ [%{getcwd()}]                    " current dir
        " set statusline+=\ [A=\%03.3b/H=\%02.2B]          " ASCII / Hexadecimal value of char
        set statusline+=%=%-14.(%l,%c%V%)\ %p%%            " Right aligned file nav info
    endif

    set backspace=indent,eol,start                         " backspace for dummys
    set linespace=0                                        " No extra spaces between rows
    set number                                             " Line numbers on
    set showmatch                                          " show matching brackets/parenthesis
    set incsearch                                          " find as you type search
    set hlsearch                                           " highlight search terms
    set winminheight=0                                     " windows can be 0 line high
    set ignorecase                                         " case insensitive search
    set smartcase                                          " case sensitive when uc present
    set wildmenu                                           " show list instead of just completing
    set wildmode=list:longest,full                         " command <Tab> completion, list matches, then longest common part, then all.
    set whichwrap=b,s,h,l,<,>,[,]                          " backspace and cursor keys wrap to
    set scrolljump=5                                       " lines to scroll when cursor leaves screen
    set scrolloff=3                                        " minimum lines to keep above and below cursor
    set foldenable                                         " auto fold code
    set gdefault                                           " the /g flag on :s substitutions by default
    set list
    set listchars=tab:>.,trail:.,extends:#,nbsp:.          " Highlight problematic whitespace
    " }

" Formatting {
    set nowrap        " wrap long lines
    set autoindent    " indent at the same level of the previous line
    set shiftwidth=4  " use indents of 4 spaces
    set expandtab     " tabs are spaces, not tabs
    set tabstop=4     " an indentation every four columns
    set softtabstop=4 " let backspace delete indent
    "set matchpairs+=<:>                " match, to be used with %
    set pastetoggle=<F12>              " pastetoggle (sane indentation on pastes)
    "set comments=sl:/*,mb:*,elx:*/  " auto format comment blocks
    " Remove trailing whitespaces and ^M chars
    autocmd FileType c,cpp,java,php,js,python,twig,xml,yml autocmd BufWritePre <buffer> :call setline(1,map(getline(1,"$"),'substitute(v:val,"\\s\\+$","","")'))
    " }

" Key (re)Mappings {

    "The default leader is '\', but many people prefer ',' as it's in a standard
    "location
    let mapleader = ','
    " Making it so ; works like : for commands. Saves typing and eliminates :W style typos due to lazy holding shift.
    nnoremap ; :

    " Professor VIM says '87% of users prefer jj over esc', jj abrams disagrees
    imap jj <Esc>

    " Easier moving in tabs and windows
    map <C-J> <C-W>j<C-W>_
    map <C-K> <C-W>k<C-W>_
    map <C-L> <C-W>l<C-W>_
    map <C-H> <C-W>h<C-W>_

    " Wrapped lines goes down/up to next row, rather than next line in file.
    nnoremap j gj
    nnoremap k gk

    " The following two lines conflict with moving to top and bottom of the
    " screen
    " If you prefer that functionality, comment them out.
    map <S-H> gT
    map <S-L> gt

    " Stupid shift key fixes
    cmap W w
    cmap WQ wq
    cmap wQ wq
    cmap Q q
    cmap Tabe tabe

    " Yank from the cursor to the end of the line, to be consistent with C and D.
    nnoremap Y y$

    " Code folding options
    nmap <leader>f0 :set foldlevel=0<CR>
    nmap <leader>f1 :set foldlevel=1<CR>
    nmap <leader>f2 :set foldlevel=2<CR>
    nmap <leader>f3 :set foldlevel=3<CR>
    nmap <leader>f4 :set foldlevel=4<CR>
    nmap <leader>f5 :set foldlevel=5<CR>
    nmap <leader>f6 :set foldlevel=6<CR>
    nmap <leader>f7 :set foldlevel=7<CR>
    nmap <leader>f8 :set foldlevel=8<CR>
    nmap <leader>f9 :set foldlevel=9<CR>

    "clearing highlighted search
    nmap <silent> <leader>/ :nohlsearch<CR>

    "clearing line numbering
    nnoremap <F2> :set nonumber!<CR>:set foldcolumn=0<CR>
    "clearing decorations from spell, trailed space, tab ...
    nnoremap <F3> :set nospell!<CR>:set list!<CR>

    " Shortcuts
    " Change Working Directory to that of the current file
    cmap cwd lcd %:p:h
    cmap cd. lcd %:p:h

    " visual shifting (does not exit Visual mode)
    vnoremap < <gv
    vnoremap > >gv

    " Fix home and end keybindings for screen, particularly on mac
    " - for some reason this fixes the arrow keys too. huh.
    map [F $
    imap [F $
    map [H g0
    imap [H g0

    " For when you forget to sudo.. Really Write the file.
    cmap w!! w !sudo tee % >/dev/null
" }

" Plugins {
    " Supertab {
        let g:SuperTabDefaultCompletionType = "context"
        let g:SuperTabContextDefaultCompletionType = "<c-x><c-o>"
    " }

    " OmniComplete {
        "autocmd Filetype *
                "\if &omnifunc == "" |
                "\setlocal omnifunc=syntaxcomplete#Complete |
                "\endif
        "endif

        " Popup menu hightLight Group
        "highlight Pmenu    ctermbg=13    guibg=DarkBlue
        "highlight PmenuSel    ctermbg=7    guibg=DarkBlue        guifg=LightBlue
        "highlight PmenuSbar ctermbg=7    guibg=DarkGray
        "highlight PmenuThumb            guibg=Black

        hi Pmenu  guifg=#000000 guibg=#F8F8F8 ctermfg=black ctermbg=Lightgray
        hi PmenuSbar  guifg=#8A95A7 guibg=#F8F8F8 gui=NONE ctermfg=darkcyan ctermbg=lightgray cterm=NONE
        hi PmenuThumb  guifg=#F8F8F8 guibg=#8A95A7 gui=NONE ctermfg=lightgray ctermbg=darkcyan cterm=NONE

        " some convenient mappings
        inoremap <expr> <Esc>      pumvisible() ? "\<C-e>" : "\<Esc>"
        inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"
        inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
        inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
        inoremap <expr> <C-d>       pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<C-d>"
        inoremap <expr> <C-u>      pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<C-u>"

        " and make sure that it doesn't break supertab
        let g:SuperTabCrMapping = 0

        " automatically open and close the popup menu / preview window
        au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
        set completeopt=menu,preview,longest
    " }


    " NerdTree {
        map <C-e> :NERDTreeToggle<CR>:NERDTreeMirror<CR>
        nmap <leader>nt :NERDTreeFind<CR>

        let NERDTreeShowBookmarks=1
        let NERDTreeIgnore=['\.pyc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr']
        let NERDTreeChDirMode=0
        let NERDTreeQuitOnOpen=1
        let NERDTreeShowHidden=0
        let NERDTreeKeepTreeInNewTab=1
    " }

    " AutoCloseTag {
        " Make it so AutoCloseTag works for xml and xhtml files as well
        autocmd FileType xhtml,xml runtime ftplugin/html/autoclosetag.vim
    " }
    " Tabularize {
    if exists(":Tabularize")
        nmap <Leader>a= :Tabularize /=<CR>
        vmap <Leader>a= :Tabularize /=<CR>
        nmap <Leader>a: :Tabularize /:<CR>
        vmap <Leader>a: :Tabularize /:<CR>
        nmap <Leader>a:: :Tabularize /:\zs<CR>
        vmap <Leader>a:: :Tabularize /:\zs<CR>
        nmap <Leader>a, :Tabularize /,<CR>
        vmap <Leader>a, :Tabularize /,<CR>
        nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
        vmap <Leader>a<Bar> :Tabularize /<Bar><CR>
    endif
    " }
    " VCS commands {
        nmap <leader>vs :VCSStatus<CR>
        nmap <leader>vc :VCSCommit<CR>
        nmap <leader>vb :VCSBlame<CR>
        nmap <leader>va :VCSAdd<CR>
        nmap <leader>vd :VCSVimDiff<CR>
        nmap <leader>vl :VCSLog<CR>
        nmap <leader>vu :VCSUpdate<CR>
    " }
    " Fuzzy Finder {
        """ Fuzzy Find file, tree, buffer, line
        nmap <leader>ff :FufFile **/<CR>
        nmap <leader>ft :FufFile<CR>
        nmap <leader>fb :FufBuffer<CR>
        nmap <leader>fl :FufLine<CR>
        nmap <leader>fr :FufRenewCache<CR>
    " }
    " Taglist Variables {
        let Tlist_Auto_Highlight_Tag = 1
        let Tlist_Auto_Update = 1
        let Tlist_Exit_OnlyWindow = 1
        let Tlist_File_Fold_Auto_Close = 1
        let Tlist_Highlight_Tag_On_BufEnter = 1
        let Tlist_Use_Right_Window = 1
        let Tlist_Use_SingleClick = 1

        let g:ctags_statusline=1
        " Override how taglist does javascript
        let g:tlist_javascript_settings = 'javascript;f:function;c:class;m:method;p:property;v:global'
    " }
    " python-mode {
        let g:pymode_utils_onfly = 1
        let g:pymode_lint_checker = "pyflakes,pep8"
        let g:pymode_lint_write = 0
    " }
" }


" GUI Settings {
    " GVIM- (here instead of .gvimrc)
    if has('gui_running')
        set guioptions-=T              " remove the toolbar
        set lines=40                   " 40 lines of text instead of 24,
        set guifont=Monaco:h12
    endif
" }

" Use local vimrc if available {
    if filereadable(expand("~/.vimrc.local"))
        source ~/.vimrc.local
    endif
" }
