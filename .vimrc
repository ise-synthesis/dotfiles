" 文字コードの自動認識
if &encoding !=# 'utf-8'
	set encoding=japan
	set fileencoding=japan
endif
if has('iconv')
	let s:enc_euc = 'euc-jp'
	let s:enc_jis = 'iso-2022-jp'
	" iconvがeucJP-msに対応しているかをチェック
	if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
		let s:enc_euc = 'eucjp-ms'
		let s:enc_jis = 'iso-2022-jp-3'
		" iconvがJISX0213に対応しているかをチェック
	elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
		let s:enc_euc = 'euc-jisx0213'
		let s:enc_jis = 'iso-2022-jp-3'
	endif
	" fileencodingsを構築
	if &encoding ==# 'utf-8'
"		let s:fileencodings_default = &fileencodings
"		let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
"		let &fileencodings = &fileencodings .','.  s:fileencodings_default
"		unlet s:fileencodings_default
		let &fileencodings = s:enc_jis .',utf-8,'. s:enc_euc .',cp932'
	else
		let &fileencodings = &fileencodings .','. s:enc_jis
		set fileencodings+=utf-8,ucs-2le,ucs-2
		let &fileencodings = s:enc_jis
		set fileencodings+=utf-8
		if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
			set fileencodings+=cp932
			set fileencodings-=euc-jp
			set fileencodings-=euc-jisx0213
			set fileencodings-=eucjp-ms
			let &encoding = s:enc_euc
			let &fileencoding = s:enc_euc
		else
			let &fileencodings = &fileencodings .','.  s:enc_euc
		endif
	endif
	" 定数を処分
	unlet s:enc_euc
	unlet s:enc_jis
endif

" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
	function! AU_ReCheck_FENC()
		if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
			let &fileencoding=&encoding
		endif
	endfunction
	autocmd BufReadPost * call AU_ReCheck_FENC()
endif

" … などを 2byte 幅として扱う
set ambiwidth=double

" 改行コード
set fileformats=unix,dos,mac
" ステータスラインに文字コード改行コードを表示する
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P
" TAB 幅
set tabstop=2
set shiftwidth=2
set expandtab
" 勝手に改行されるのを止める (0 だと上書きしてくるプラグインとかあるから大きめで 200)
set textwidth=200
" 行番号表示
set number
" modeline 有効
set modeline
" ステータスラインを表示
set laststatus=2
" 括弧入力時に対応する括弧を表示
set showmatch
" バックアップファイル hoge~ を作る
set backup
" list 表示の時の TAB を >--- にする
set listchars=tab:>-,eol:$
" メッセージを日本語で
"language ja_JP.eucJP

set t_Co=256

" 黒背景のハイライト表示にする(syntax enableより先に設定する必要有)
set background=dark
" インクリメンタルサーチする
set incsearch
" 検索結果をハイライト表示
set hlsearch
" 検索で巡回をしないように
set nowrapscan
" ファイル形式別プラグイン & インデント機能
filetype plugin indent on

set makeprg=make

"map <F3> :source $CVIMSYN/engspchk.vim

" ソースに色をつける
syntax enable

"matchit プラグインを有効化
source $VIMRUNTIME/macros/matchit.vim

"" Solarized テスト
"let g:solarized_termcolors=16
"let g:solarized_termtrans=0
"let g:solarized_degrade=0
"let g:solarized_bold=1
"let g:solarized_underline=1
"let g:solarized_italic=1
"let g:solarized_contrast='normal'
"let g:solarized_visibility='normal'
"colorscheme solarized

" 全角スペースに色づけ
highlight ZenkakuSpece term=underline ctermbg=lightblue guibg=white
match ZenkakuSpece /　/

" .vh も Verilog と思う
augroup filetypedetect
	au! BufRead,BufNewFile *.vh setfiletype verilog
augroup END

" vim -b *.bin で勝手に 16 進ダンプ形式に
" vim -b : edit binary using xxd-format!
augroup Binary
	au!
	au BufReadPre  *.bin let &bin=1
	au BufReadPost *.bin if &bin | silent %!xxd -g 1
	au BufReadPost *.bin set ft=xxd | endif
	au BufWritePre *.bin if &bin | %!xxd -r
	au BufWritePre *.bin endif
	au BufWritePost *.bin if &bin | silent %!xxd -g 1
	au BufWritePost *.bin set nomod | endif
augroup END

" Align.vim の文字列長さ判定設定
let g:Align_xstrlen = 3

" vimdiff の色
highlight DiffAdd    cterm=bold ctermfg=10 ctermbg=22
highlight DiffDelete cterm=bold ctermfg=10 ctermbg=52
highlight DiffChange cterm=bold ctermfg=10 ctermbg=17
highlight DiffText   cterm=bold ctermfg=10 ctermbg=21
