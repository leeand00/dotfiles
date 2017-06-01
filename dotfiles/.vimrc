set nocompatible
" BEGIN Add Vundle
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Plugin 'tmhedberg/SimpylFold'
Plugin 'Valloric/YouCompleteMe'

" Add all your plugins here (note older versions of Vundle used Bundle instead of Plugin)

call vundle#end() 	  " Required
filetype plugin indent on " Required
" END Add Vundle

source $VIMRUNTIME/vimrc_example.vim
" source $VIMRUNTIME/mswin.vim
" behave mswin

" BEGIN Python indent
au BufNewFile.BufRead *.py
    \ set tabstop=4
    \ set softtabstop=4
    \ set shiftwidth=4
    \ set textwidth=79
    \ set expandtab
    \ set autoindent
    \ set fileformat=unix
" END Python indent

" BEGIN Python Flag Unnecessary Whitespace
" This will mark extra whitespace as bad, and probably color it red.
" END Python Flag Unnecessary Whitespace

set encoding=utf-8

command! -complete=shellcmd -nargs=+ Shell call s:RunShellCommand(<q-args>)
function! s:RunShellCommand(cmdline)
  echo a:cmdline
  let expanded_cmdline = a:cmdline
  for part in split(a:cmdline, ' ')
     if part[0] =~ '\v[%#<]'
        let expanded_part = fnameescape(expand(part))
        let expanded_cmdline = substitute(expanded_cmdline, part, expanded_part, '')
     endif
  endfor
  botright new
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  call setline(1, 'You entered:    ' . a:cmdline)
  call setline(2, 'Expanded Form:  ' .expanded_cmdline)
  call setline(3,substitute(getline(2),'.','=','g'))
  execute '$read !'. expanded_cmdline
  setlocal nomodifiable
  1
endfunction

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

" Include abbreviations for adding skills to a filter.
source ~/.vimrc_ab_skills


" set the CTRL+X CTRL+K dictionary so that we can do autocomplete on job
" skills.
set dict+=/home/leeand00/Documents/lifehacker\ organized/docs/jobhunt/skills_list/skills_list.txt
set iskeyword+=-



function! GetJobLines(skillz)

	" 1. Create a new buffer for the output
	enew

	" 2. Change directory to location of said script
	cd /home/leeand00/Documents/lifehacker\ organized/docs/jobhunt/jobhuntshared/src/tiddlerpull/

        " execute "read!echo ". shellescape(a:skillz)

	" 3. Run said script with argument
	execute "read!cat sec.txt | xargs -I{} -n 1 node ./index.js skills=". fnameescape(a:skillz) ." job=\"[[Database Analyst - Net Tech - MIS - Help Desk]]\" sec=\"{}\""
	execute "read!cat job.txt | xargs -I{} -n 1 node ./index.js skills=". fnameescape(a:skillz) ."  job=\"[[{}]]\" "

	" 4. Clean out those node deprecation errors (probably ought to fix
	" that in the actual script though)
	g/(node)/d
endfunction

function! CleanTw5CP()
	g/^$/d
	%s/\W\{4\}//g
endfunction

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

" 1. Input a text file formatted with different tiddlers
"    for jq to slurp up and parse into json for tw5.
function! TW5GenNUpload(txtFile, user, host, wikipath)

	let l:tempJSONFile = tempname() . '.json'
	let l:username_hostname = a:user . "@" . a:host


	" ! jq -Rs . ~/Documents/tw5jqimport/test1.txt | jq -s ' . [] | split("----")' | jq '. [] | gsub("^\n\n";"")' | jq -s '. []' | jq -s '. [] | split("\n") | map(select(length > 0)) | (.[0] | gsub("^!";"") ) as $title | (.[1] | gsub("^%";"") ) as $order | ( .[2] | gsub("^;";"") ) as $caption | ( .[3] | gsub("&";"" ) ) as $tags | (.[4:length] | join ("\n")) as $text | {"title":$title, "text":$text, "caption":$caption, "order":$order, "tags":$tags }' | jq -s '.' > /tmp/bob.json
	:exec "! jq -Rs . " . a:txtFile . "| jq -s \' . [] | split(\"----\")\' | jq \'. [] | gsub(\"^\\n\\n\";\"\")\' | jq -s \'. []\' | jq -s \'. [] | split(\"\\n\") | map(select(length > 0)) | (.[0] | gsub(\"^\\!\";\"\") ) as $title | (.[1] | gsub(\"^\\%\";\"\") ) as $order | (.[2] | gsub(\"^;\";\"\") ) as $caption | (.[3] | gsub(\"^&\";\"\") ) as $tags | (.[4:length] | join(\"\\\n\")) as $text | { \"title\":$title, \"order\":$order, \"caption\":$caption, \"tags\":$tags, \"text\":$text } \' | jq -s \'.\' > " . l:tempJSONFile 

	" 2. Create the file remotely in the /tmp path on the wiki machine...
	:exec "! ssh " . username_hostname .  " \"  mkdir -p " . fnamemodify(l:tempJSONFile, ":h") . "\""

	" 3. Transfer the file..
	:exec "! scp " . l:tempJSONFile . " " . username_hostname . ":" .  l:tempJSONFile

	" 4. Load the file with tiddlywiki --load l:tempJSONFile remotely...
	:exec "! ssh " . username_hostname .  " \" tiddlywiki " . wikipath . " --load " . l:tempJSONFile . "\" >> /tmp/tw5load.log"
	
	" 5. Refresh your browser...

	echom l:tempJSONFile
endfunction

" NOTE: Remap this when you write use a new file for tw5.
map <F6> :call TW5GenNUpload("dotfiles/dotfiles/tw5article_test.txt", "pi", "pi.leerdomain.lan", "/home/pi/tw5/linux")
