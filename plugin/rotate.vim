"=============================================================================
" File: rotate.vim
" Author: Jens Paulus <jpaulus@freenet.de>
" Last Change:	2005 Jan 12
" Version: 1.0
"-----------------------------------------------------------------------------
" This file enables Vim to rotate or rearrange text.
"-----------------------------------------------------------------------------
" To use this file put it in your plugin directory and it will be sourced.
" If not, you must manually source this file using :source rotate.vim<Return>.
"
" This file provides the function Rotate() which does the work and the commands
" Rot [arg], Srot [arg], Rotv [arg], Srotv [arg] which call the function with
" the right arguments.
" The commands that begin with "S" open the result in a new window.
" The commands that end with "v" are for use in Visual mode.
" The commands accept an optional argument [arg] to specify the desired action,
" it corresponds to the first argument in the function, see below.
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
"         h the text is reordered from right to left
"         v the text is reordered from bottom to top
"         l the text is rotated counter clockwise
"         r the text is rotated clockwise
"         u the text is put upside down
" If a is 0 the text is a linewise region
"         1 the text is a visual selection
" If b is 0 the resulting text will replace the original text
"         1 the resulting text will appear in a new window
"=============================================================================
"
" l(T) = v(x(T)) = x(h(T))
" r(T) = x(v(T)) = h(x(T))
" u(T) = v(h(T)) = h(v(T))

" Test if this plugin has already been loaded
if exists("loaded_rotate")
finish
endif
let loaded_rotate=1

function Rotate(char,vimode,newwin) range
if a:char==""
let flag="x"
else
let flag=tolower(a:char)
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
1d _
let maxlen=0
%g/^/if col("$")>maxlen|let maxlen=col("$")|endif
%g/^/if col("$")<maxlen|exe "norm! ".(maxlen-col("$"))."A "|endif
if (flag=="r")||(flag=="v")
2,$g/^/m 0
endif
if (flag=="x")||(flag=="r")||(flag=="l")
norm! G0mc
while col("$")>1
exe "norm! \<C-V>god"
$put
.,$j!
norm! `c
endwhile
1,'cd _
endif
if (flag=="h")||(flag=="u")
exe "norm! G0mc\<C-V>god$p"
while col(".")>2
norm! h`c
exe "keepj norm! \<C-V>god"
norm! ``P
endwhile
endif
if (flag=="l")||(flag=="u")
2,$g/^/m 0
endif
norm! go
unlet maxlen
if a:newwin==0
exe "norm! go\<C-V>G$y"
q!
if a:vimode==0
exe "norm! ".a:firstline."GV".a:lastline."Gp"
else
norm! gvp
endif
endif
unlet flag
endfunction

command -range -nargs=? Rot <line1>,<line2>call Rotate(<q-args>,0,0)
command -range -nargs=? Srot <line1>,<line2>call Rotate(<q-args>,0,1)
command -range -nargs=? Rotv <line1>,<line2>call Rotate(<q-args>,1,0)
command -range -nargs=? Srotv <line1>,<line2>call Rotate(<q-args>,1,1)


