"=============================================================================
" File: rotate.vim
" Author: Jens Paulus <jpaulus@freenet.de>
" Last Change: 2005 Feb 12
" Version: 1.6
"-----------------------------------------------------------------------------
" This file enables Vim to rotate or rearrange text.
"-----------------------------------------------------------------------------
" To use this file put it in your plugin directory. If not, you must manually
" source it by entering :source rotate.vim<Return>.
"
" This file provides the function Rotate() and the commands
" Rot [arg], Srot [arg], Rotv [arg], Srotv [arg] which call the function with
" the right arguments.
" The commands beginning with "S" open the result in a new window.
" The commands ending with "v" operate on the latest Visual mode region.
" All commands accept an optional argument [arg] to specify the desired action,
" it is one of x, h, v, l, r, u, see below.
" If no argument is specified, then lines and columns are exchanged.
"
" Examples:
" :5,8Rot     exchanges lines and columns of lines 5 to 8.
" :%Srot u    puts the text upside down and opens the result in a new window.
" :vmap \l :Rotv l    rotates the selected text counter clockwise with \l
" :vmap \r :Rotv r    rotates the selected text clockwise with \r
"
" The function usage is :<range>call Rotate("c",a,b) where c,a,b are as follows.
" If c is x lines and columns are exchanged, this is the default action
"         h the text columns are reordered from right to left
"         v the text lines are reordered from bottom to top
"         l the text is rotated counter clockwise
"         r the text is rotated clockwise
"         u the text is put upside down
" If a is 0 the text is a linewise region
"         1 the text is a visual selection
" If b is 0 the resulting text will replace the original text
"         1 the resulting text will appear in a new window
"=============================================================================
"
" Test if this plugin has already been loaded
if exists("loaded_rotate")
finish
endif
let loaded_rotate=1

function Rotate(char,vimode,newwin) range
if a:char==""
let s:flag="x"
else
let s:flag=tolower(a:char)
endif
setlocal report=996
if a:vimode==0
exe a:firstline.",".a:lastline."y"
else
norm! gvy
endif
new
setlocal tw=0
put
1d_
let s:maxlen=0
%g/^/if col("$")>s:maxlen|let s:maxlen=col("$")|endif
%g/^/if col("$")<s:maxlen|exe "norm! ".(s:maxlen-col("$"))."A \<Esc>"|endif
let s:maxlen=s:maxlen-1
kc
if s:flag=="x"
let s:cpos=0
while s:cpos<s:maxlen
call setreg(0,"")
let s:lpos=1
while s:lpos<=line("'c")
call setreg(0,getline(s:lpos)[s:cpos],"a")
let s:lpos=s:lpos+1
endwhile
put0
let s:cpos=s:cpos+1
endwhile
unlet s:lpos
unlet s:cpos
1,'cd_
endif
if s:flag=="l"
let s:cpos=s:maxlen-1
while s:cpos>=0
call setreg(0,"")
let s:lpos=1
while s:lpos<=line("'c")
call setreg(0,getline(s:lpos)[s:cpos],"a")
let s:lpos=s:lpos+1
endwhile
put0
let s:cpos=s:cpos-1
endwhile
unlet s:lpos
unlet s:cpos
1,'cd_
endif
if s:flag=="r"
let s:cpos=0
while s:cpos<s:maxlen
call setreg(0,"")
let s:lpos=line("'c")
while s:lpos>0
call setreg(0,getline(s:lpos)[s:cpos],"a")
let s:lpos=s:lpos-1
endwhile
put0
let s:cpos=s:cpos+1
endwhile
unlet s:lpos
unlet s:cpos
1,'cd_
endif
if s:flag=="u"
let s:lpos=line("'c")
while s:lpos>0
call setreg(0,"")
let s:cpos=s:maxlen-1
while s:cpos>=0
call setreg(0,getline(s:lpos)[s:cpos],"a")
let s:cpos=s:cpos-1
endwhile
put0
let s:lpos=s:lpos-1
endwhile
unlet s:cpos
unlet s:lpos
1,'cd_
endif
if s:flag=="h"
exe "norm! G0mc\<C-V>god$p"
while col(".")>2
norm! h`c
exe "keepj norm! \<C-V>god"
norm! ``P
endwhile
endif
if s:flag=="v"
2,$g/^/m0
endif
norm! go
unlet s:maxlen
unlet s:flag
if a:newwin==0
exe "norm! go\<C-V>G$y"
q!
if a:vimode==0
exe "norm! ".a:firstline."GV".a:lastline."Gp"
else
norm! gvp
endif
endif
endfunction

command -range -nargs=? Rot <line1>,<line2>call Rotate(<q-args>,0,0)
command -range -nargs=? Srot <line1>,<line2>call Rotate(<q-args>,0,1)
command -range -nargs=? Rotv <line1>,<line2>call Rotate(<q-args>,1,0)
command -range -nargs=? Srotv <line1>,<line2>call Rotate(<q-args>,1,1)


