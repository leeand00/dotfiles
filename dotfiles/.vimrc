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

" Format a Tiddywiki5 Matrix Table
" 
" After calling Excel2TW5(), 
" If your table has a grid of values, 
" this function centers them and right justifies the
" first column.
function! FormatTW5MatrixTable()
	" Shift everything to the right.
	%s/|\(.\{-\}\)/| \1 /g

	" Remove whitespace at the end.
	%s/  $//g

	" Center everything.
	%s/\(.\)|/\1 |/g

	" Call this function for every line in the table
	%g/.*/call FormatTW5MatrixTableRightJustify()
endfunction

function FormatTW5MatrixTableRightJustify()
	" Go to the first line.
	normal ^

	" Jump to the first pipe after the cursor.
	normal 1f|

	" Move left and delete the space, then move
	" down a line.
	normal hxj
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

" CCure Setup
function! DCWSetup()
	call CCure_Dup_lname()
	call CCure_DCW()
	call CCure_Badge_Layout()
	call CCure_PortraitFile()
endfunction


" 1
function! CCure_Dup_lname()
	'<,'>s/^[A-Za-z]\+ \([A-Za-z]\+\)/\0,\1,/
endfunction

" 2
function! CCure_DCW()
	'<,'>s/$/,Direct Care Worker,/
endfunction

" 2
function! CCure_RPW()
	'<,'>s/$/Program Worker,Residential,
endfunction

function! CCure_Floater()
	'<,'>s/$/Direct Care Worker,Floating,
endfunction

" 4
function! CCure_Badge_Layout()
	'<,'>s/$/Vertical Unlimited Care Providers,/
endfunction

" 5
function! CCure_PortraitFile()
	'<,'>s/^\([A-Za-z]\+\) \([A-Za-z]\+\).*$/\0\"\2, \1.jpg\",/
endfunction

function! CCure_FillInPath()
	" These emulates key presses
	
	" Find the third instance of a comma.
	normal 3f,  

	" 1. Move right one character
	" 2. Go into Visual Mode, Move to the next comma
	"    copy the selected text to the clipboard.
	" 3. Find the next "
	" 4. Paste from the clipboard, move one right one character,
	"    insert and put an 's' at the end of the name of the position.
	" 5. move one character to the right, type a '\'
	" 6. Move to the previous match
	" 7. Move two characters to the right
	" 8. Type F:\ID BADGES\
	" 9. Move to the end of the line and delete the last character.
	normal lvnh"+y
	normal f"
	normal "+plis
	normal li\
	normal N
	normal ll
	normal iF:\ID BADGES\
	normal $x
endfunction
