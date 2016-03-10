set nocompatible
source $VIMRUNTIME/vimrc_example.vim
" source $VIMRUNTIME/mswin.vim
" behave mswin

set diffexpr=MyDiff()
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let eq = ''
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      let cmd = '""' . $VIMRUNTIME . '\diff"'
      let eq = '"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction

set nowrap
colorscheme slate
set bs=2

set nocp
filetype plugin on

" Convert a table from pasted from excel into Tiddlywiki5 format.
function! Excel2Tw5()
	1,1s/^/|!/g
	1,1s/\t/|!/g
	1,1s/$/|/g
	2,$s/^/|/g
	2,$s/\t/|/g
	2,$s/$/|/g	
endfunction

" Make an export from Visitrax AUCP to Santrax readable in VIM.
function! AUCP_VT_Extract_ETS_Fmt()
	%s/\(0\{11\}\) \(777\)/\1\r\2/g
endfunction

"
function! GoogleFormsStep(startnum, endnum)
	
	call GoogleFormsStep1()

	let x = a:startnum
	let line = 1
	
	while x <= a:endnum

	  execute line . "," . line . "s/$/" . x . "/g"
	  
	  let x = x + 1
	  let line = line + 1
	endwhile


	call GoogleFormsStep2()

endfunction

function! AddTW5Links(tiddlerSetName) 
	:exe '%s/\(*\+\)\(\[\[\(.*\)\)\]\]/\1[[\3|\3 - '.a:tiddlerSetName.']]/g'
endfunction

" 
function! GoogleFormsStep1()
	%s/^/\tcopyBody.replaceText('/g
	%s/$/', e.values[/g
endfunction

"
function! GoogleFormsStep2()
	%s/$/]);/g
endfunction

function! NormalTest()
	normal n
endfunction
