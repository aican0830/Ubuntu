" local syntax file - set colors on a per-machine basis:
" vim: tw=0 ts=4 sw=4
" Vim color file
" Maintainer:	Ron Aaron <ron@ronware.org>
" Last Change:	2003 May 02

hi clear
set background=dark

syntax on
if exists("syntax_on")
  syntax reset
endif

"打开文件后返回上次编辑位置
"==============================================================================
" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
  " 不仅回到上次编辑的那一行，更把那一行居中显示
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") 
              \| exe "normal g'\"zz" | endif
endif

" Uncomment the following to have Vim load indentation rules according to the
" detected filetype. Per default Debian Vim only load filetype specific
" plugins.
if has("autocmd")
  filetype plugin indent on
endif


"Set 7 lines to the curors - when moving vertical..
"set scrolloff=7

"Turn on WiLd menu
"打开新文件时候在statusline显示列表
set wildmenu

"The commandbar is 2 high
set cmdheight=3




" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
set incsearch		" Incremental search
"set autowrite		" Automatically save before commands like :next and :make
"set hidden             " Hide buffers when they are abandoned
set mouse=a		" Enable mouse usage (all modes) in terminals

"tab设置
"==============================================================================
set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab "replace tab with space
set smarttab  "easy when you use backspace


"光标在行间自由移动
"==============================================================================
set whichwrap=b,s,h,l,<,>,[,]


"直接按下K键也可以查看Man page
"==============================================================================
source $VIMRUNTIME/ftplugin/man.vim


"配色，gnome-terminal下是elflord，gVim下是koehler
"==============================================================================
colorscheme elflord
"tab标签栏配色
hi TabLine		  term=bold,reverse  cterm=bold ctermfg=black ctermbg=white gui=bold guifg=blue guibg=white
hi TabLineFill	  term=bold,reverse  cterm=bold ctermfg=lightblue ctermbg=white gui=bold guifg=blue guibg=white
hi TabLineSel	  term=reverse	ctermfg=white ctermbg=lightblue guifg=white guibg=blue
hi Pmenu      guibg=LightBlue
hi PmenuSel   ctermfg=White	   ctermbg=DarkBlue  guifg=White  guibg=DarkBlue
"定义特殊高亮颜色
hi Special ctermfg=blue
hi Function ctermfg=blue
hi Folded ctermbg=NONE ctermfg=darkgreen
if has("autocmd")
    au GUIEnter * colorscheme desert
endif


"PHP智能补全函数，使用F8来自动选择Ctrl+N还是Ctrl+X+O
"==============================================================================
function! CleverTab()
            if pumvisible()
              return "\<C-N>"
            endif
    if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
       return "\<Tab>"
            elseif exists('&omnifunc') && &omnifunc != ''
               return "\<C-X>\<C-O>"
            else
               return "\<C-N>"
           endif
endfunction


"代码文件通用设置
"==============================================================================
"F8自动补齐
inoremap <F8> <C-X><C-O>
if has("autocmd")
    "代码折叠
    "==============================================================================
    "设置php折叠方式
    let php_folding=2
    set fillchars=stl:^,stlnc:-,vert:\|,fold:\ ,diff:-
    autocmd filetype html,xhtml,javascript set foldmethod=indent
    "默认为打开所有折叠
    if has("folding")
        " Open this file at first
        exe "normal " . "zR"
        " Let it works during the editing period
        set foldlevelstart=99
    endif

    "PHP相关
    "==============================================================================
    "F8自动补齐，比Ctrl+X+O方便一些
    autocmd filetype php inoremap <F8> <C-R>=CleverTab()<CR>
    "Ctrl+J检查PHP脚本错误
    autocmd filetype php nnoremap <silent> <C-J> :w<CR>:!php -l %<CR>
    "K看函数文档
    autocmd filetype php set keywordprg=~/.vim_php_k
    "Ctrl+P执行脚本
    if has("gui_running")
        "（在gvim下有显示不全和无法记录的bug，因此要打开一个gnome-terminal窗口来执行脚本）
        autocmd filetype php nnoremap <silent> <C-P> :w<CR>:silent! !gnome-terminal -t "php %" --maximize --hide-menubar -x bash -c "php % ; echo ; read -n1 -p 'Press any key to continue'"<CR>
    else
        autocmd filetype php nnoremap <silent> <C-P> :w<CR>:!php %<CR>
    endif

    "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    "php中架构下devcache用到的{#..}语法高亮
    autocmd filetype php syn match phpIdentifier "#\h\w*"  contained contains=phpEnvVar,phpIntVar,phpVarSelector display
    autocmd filetype php syn region  phpIdentifierComplex  matchgroup=phpParent start="{\#"rs=e-1 end="}"  contains=phpIdentifier,phpMemberSelector,phpVarSelector,phpIdentifierComplexP contained extend

    "在gnome-terminal下使用vim编辑php时matchparen会导致移动光标狠慢，需要关闭，但是在gvim下正常，可以保留
    if has("gui_running") < 1
        let loaded_matchparen = 1
    endif
    "Javascript相关，需要按照SpiderMonkey-bin
    "==============================================================================
    "Ctrl+J检查脚本错误
    autocmd filetype javascript nnoremap <silent> <C-J> :w<CR>:!js -Cws %<CR>
    "Ctrl+P执行脚本
    if has("gui_running")
        autocmd filetype javascript nnoremap <silent> <C-P> :w<CR>:silent! !gnome-terminal -t "js %" --maximize --hide-menubar -x bash -c "js -ws % ; echo ; read -n1 -p 'Press any key to continue'"<CR>
    else
        autocmd filetype javascript nnoremap <silent> <C-P> :w<CR>:!js -ws %<CR>
    endif

    "nginx配置文件
    "==============================================================================
    autocmd BufNewFile,BufRead *nginx* set filetype=nginx

    "html创建新文件时使用模板
    "==============================================================================
    autocmd BufNewFile *.html 0r ~/.vim_html
    autocmd BufNewFile *.xhtml 0r ~/.vim_html
endif

"常用注释自动补齐
"==============================================================================
ab /*** /******************************************************************************/
ab /// ////////////////////////////////////////////////////////////////////////////////
ab loggo l_log("it is called ~~~~~~~~~~~~!!!!!!!!!----");


"Tabline标签栏设置
"==============================================================================
set showtabline=2
"函数定义
if exists("+guioptions")
     set go-=a go-=e go+=t
endif
if exists("+showtabline")
    function! MyTabLine()
        let s = ''
        let t = tabpagenr()
        let i = 1
        let len = 0
        let div = &columns - 4
        let list = []

        while i <= tabpagenr('$')
            let s .= '%' . i . 'T'
            let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')

            let buflist = tabpagebuflist(i)
            let winnr = tabpagewinnr(i)
            let file = bufname(buflist[winnr - 1])
            let file = fnamemodify(file, ':p:t')
            if file == ''
                let file = '[No Name]'
            endif

            if getbufvar(buflist[winnr-1], "&modified")
                let s .= '+'
            else
                let s .= ' '
            endif
            let s .= file.' '

            let ll = strlen(substitute(file, '[^\x00-\xff]', 'xx', 'g')) + 2
            let len = len + ll
            if len > div
                let div = &columns - 8
                call add(list, i)
                let len = ll
            endif

            let i = i + 1
        endwhile

        "计算当tabline过长时，起始tab和终止tab应该是哪些，焦点是当前选中的tab，分割tab
        let starti = 0
        let endi = 0
        if len(list) == 0
            let s .= '%T%#TabLineFill#%='
        else
            for i in list
                if t >= starti && t<i
                    let endi = i
                    break
                else
                    let starti = i
                endif
            endfor

            let startpos = stridx(s, '%'.starti.'T%#TabLine')
            if endi == 0
                "最后一段
                let s = '<<< ' . strpart(s, startpos) . '%T%#TabLineFill#%='
            else
                "前面一段或者中间一段
                let endpos = stridx(s, '%'.endi.'T%#TabLine')
                let s = strpart(s, startpos, endpos-startpos) . '%T%#TabLineFill#%=' . ' >>>'

                if starti != 0
                    "中间一段
                    let s = '<<< ' . s
                endif
            endif
        endif

        return s
    endfunction
    set tabline=%!MyTabLine()
endif 

"最多打开30个文件
set tabpagemax=30
"Tab来回切换标签页
nnoremap <Tab> :tabn<CR>
nnoremap <S-Tab> :tabp<CR>
"Ctrl+O打开新标签页
nnoremap <C-O> :tabnew<Space>
"Ctrl+N打开新标签页，不打开文件
nnoremap <C-N> :tabnew<CR>:NERDTreeToggle<CR>
"tabline标签栏部分设置完成

"<Alt-1>、<Alt-2>、<Alt-3>快速选择Tab页
"只在gVim下起作用不然在gnome-terminal下会影响gnome-terminal的标签切换
au GUIEnter * inoremap <silent> <A-1> <ESC>:tabnext 1<CR>a
au GUIEnter * inoremap <silent> <A-2> <ESC>:tabnext 2<CR>a
au GUIEnter * inoremap <silent> <A-3> <ESC>:tabnext 3<CR>a
au GUIEnter * inoremap <silent> <A-4> <ESC>:tabnext 4<CR>a
au GUIEnter * inoremap <silent> <A-5> <ESC>:tabnext 5<CR>a
au GUIEnter * inoremap <silent> <A-6> <ESC>:tabnext 6<CR>a
au GUIEnter * inoremap <silent> <A-7> <ESC>:tabnext 7<CR>a
au GUIEnter * inoremap <silent> <A-8> <ESC>:tabnext 8<CR>a
au GUIEnter * inoremap <silent> <A-9> <ESC>:tabnext 9<CR>a
au GUIEnter * inoremap <silent> <A-0> <ESC>:tablast<CR>a
au GUIEnter * noremap <silent> <A-1> :tabnext 1<CR>
au GUIEnter * noremap <silent> <A-2> :tabnext 2<CR>
au GUIEnter * noremap <silent> <A-3> :tabnext 3<CR>
au GUIEnter * noremap <silent> <A-4> :tabnext 4<CR>
au GUIEnter * noremap <silent> <A-5> :tabnext 5<CR>
au GUIEnter * noremap <silent> <A-6> :tabnext 6<CR>
au GUIEnter * noremap <silent> <A-7> :tabnext 7<CR>
au GUIEnter * noremap <silent> <A-8> :tabnext 8<CR>
au GUIEnter * noremap <silent> <A-9> :tabnext 9<CR>
au GUIEnter * noremap <silent> <A-0> :tablast<CR>

"错误时静音，也不闪屏
"==============================================================================
set vb t_vb=
set novb

"打开gbk文件时编码正确
"==============================================================================
set fencs=utf-8,gbk,default,latin1
"非常有用，设置中文标点用双字节处理，不然容易导致文件内容乱七八糟
set ambiwidth=double

"设置当前行的底色
"if has("gui_running")
"    set cursorline
"    hi cursorline guibg=#333333
"endif

"向下滚屏时保留7行
"set so=7

"ctags相关
"==============================================================================
function! MyCtagTabCheck() 
    let current = tabpagenr()
    let buflist = tabpagebuflist(current)
    let winnr = tabpagewinnr(current)
    let curfile = bufname(buflist[winnr-1])
    let total = tabpagenr('$')
    let p = getpos(".")
    let i = 1

    while i <= total
        if i==current
            let i = i + 1
            continue
        endif

        let buflist = tabpagebuflist(i)
        let winnr = tabpagewinnr(i)
        let file = bufname(buflist[winnr - 1])
        if curfile == file
            "该文件已经被打开过了，关闭当前tab，定位到已经打开的tab上并移动光标
            execute "tabclose"
            let mov = i
            if i>current
                let mov = i - 1
            endif
            execute "tabn " . mov
            call setpos(".", p)
            break
        endif

        let i = i + 1
    endwhile
endfunction

"用Ctrl-K代替Ctrl-]在Tab中打开当前函数所在文件，如果Tab已经存在则直接定位到该Tab下
set tags=devtags;/
nnoremap <C-K> <C-W><C-]><C-W>T:call MyCtagTabCheck()<CR>zz

"根据文件类型自动加载lixiang.com的ctags索引文件
autocmd FileType php setlocal tags=/var/www/lixiang/devphptags
autocmd FileType javascript setlocal tags=/var/www/lixiang/devjstags


"Taglist相关
nnoremap <F7> :TlistToggle<CR><C-W><C-W>


"gnome下gvim启动时窗口自动最大化，需要先安装wmctl
"==============================================================================
function! Maximize_Window()
    silent !wmctrl -r :ACTIVE: -b add,maximized_vert,maximized_horz
    "设置gvim字体
endfunction

set guifont=Mono\ 12
"gVim不显式菜单和工具栏
set guioptions=girLte
set guioptions-=r 
"显示行号
set nu

"复制粘贴Ctrl+C和Ctrl+V符合windows习惯
"==============================================================================
nnoremap <C-V> "+gP
inoremap <C-V> z<ESC>"+gPcl
vnoremap <C-C> "+y

"设置状态栏
" Always hide the statusline
set laststatus=2

"替换路径，将/home/vito/替换为~
function! CurDir()
    let curdir = substitute(getcwd(), '/home/vito/', "~/", "g")
    return curdir
endfunction

"Format the statusline
set statusline=
set statusline+=\ %F
set statusline+=\ %h%1*%m%r%w%0* " flag
set statusline+=\ cwd:%r%{CurDir()}%h
"set statusline+=\ Line:(%l/%L):%P\ Char:%c
"只输出必要的信息
set statusline+=\ Line(%L:%P)\ Char:%c
set statusline+=\ [%{strlen(&ft)?&ft:'none'}, " filetype
set statusline+=%{&encoding}, " encoding
set statusline+=%{&fileformat}]\ time:" file format
set statusline+=%{strftime(\"%H:%M\")} " current time
set statusline+=\ %{strftime(\"%m-%d\")} " current time

"打开文件相关
"==============================================================================
"F9打开文件浏览窗口NERD_tree
nnoremap <F9> :NERDTreeToggle<CR>
"F6打开最近使用的文件列表，前提是安装mru plugin
let MRU_Window_Height = 30

"F5 for comment
vmap <F5> :s=^\(//\)*=//=g<cr>:noh<cr>
nmap <F5> :s=^\(//\)*=//=g<cr>:noh<cr>
imap <F5> <ESC>:s=^\(//\)*=//=g<cr>:noh<cr>
"F6 for uncomment
vmap <F6> :s=^\(//\)*==g<cr>:noh<cr>
nmap <F6> :s=^\(//\)*==g<cr>:noh<cr>
imap <F6> <ESC>:s=^\(//\)*==g<cr>:noh<cr>
" 查找结果高亮度显示
set hlsearch
" 设定文件浏览器目录为当前目录
set bsdir=buffer
set autochdir
set nobackup
set nowb
set noswapfile
