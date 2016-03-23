# vim cheatsheet

## folding

:set foldmethod=indent
:set foldmethod=syntax
> fold to maximum level
zM
> totally unfold
zR
> unfold 1 level
zr
> fold 1 level
zm
> open this fold
zo
> close this fold
zc

## spellcheck

Spell
SpellOff
]s
[s
zg
zw
z=
> repeat z= suggestion for all matches in current window
:spellr

## c# environment

CsGotoDef
CsFindImpl
CsFindType
CsFindUsages
CsFindMembers

## syntastic

SyntasticCheck

## Visual mode stuff:

> select whole lines
shift-v
> select columns
ctrl-v
> insert text on multiple columns (inserted on escape)
shift-i

## surround

S" Visual mode, surround "selected"
S( Visual mode, surround ( selected )
s) Visual mode, surround (selected)
ysiw<em> surround <em>word</em>
cs"' change quotes to apostrophes
ds' remove surround apostrophes

## ctrl-p

## search and replace

:noh
Ggr - external git grep

## vim grepper

## windows, splits, tabs and buffers
> create a new horizontal split
:sp
> create a new vertical split
:vs
> move between splits
ctrl-w <direction>
> make current window only one
:on 
> new window and buffer
:new
> new tab and buffer
:tabnew
> find file with word cheatsheet in it and open it
:find **cheatsheet**
> increase/decreate horizontal split
<ctrl-w> 20 -/+
> increase/decreate vertical split
<ctrl-w> 20 >/<

## Registers: macros, yanking and pasting

> remember macros and yank/paste use same registers

> yank
y
> cut
x
> paste (put)
p
> yank into register n
"ny
> clipboard register = *
> current filename in % register
> record a macro into register n
qn
> replay a macro in register n
@q
> record a recursive macro (until you hit end of file)
qn0i//j@n
> clear the a register
qaq

## misc

:Delnel
:AI
:RTW
:RemoveBadNewLines

:MakeBig
:MakeSmall

:PrettyXML
CTRL-A
:Shell cmd
:Dispatch cmd

> close quick list
:ccl
> close location list
:lcl

> delete in (brackets)
dib 
> delete AROUND () inclusive of ()
dab 
> diX w=word, b=(, B={, t=<tags/>, '=apos, "=quote

## time travelling

> revert the document to a time in the past (15 minutes)
:earlier 15m
:later n

## diffing and merging
:GL
:GR

> run current file (reload vimrc if current buffer)
:so %
> reload stored vimrc
:so ~/.vimrc

bclose
startify
bufexplorer

## global

> show context (5 lines) for every line that matches (with a divider)
:g/function/z#.5|echo "======================"
> delete every line matching pattern
:g/incorrect/d
> move all lines matching pattern to end
:g/pattern/m$
> append all matching lines to the A register
qaq:g/pattern/y A

## swapping text
> swap current char with the next
xp
> swap current char with the previous
Xp
> swap current word with the next
dawwP
> swap current word with the previous
dawbP
> swap current line with the next
ddp
> swap current line with the previous
ddkP

## scribestar

:SsWeb
:SsScripts
:SsRoot

## javascript

## emmet

## snippets

< type snippet shortcut and hit tab to explode it

### javascript

> function
fn
> debugger with jshint ignore
debug
> console.log
con
> es6 arrow function
=>
> es6 import

## nerdtree

> load with
:NERDTree
> synchronise treeview with current buffer
:NERDTreeFind

## fugitive

> show git status in a new window
> then use - to stage/unstage files
:Gstatus
> git commit (loads window for message)
:Gcommit
> Show a diff between current git copy and working copy
:Gdiff
> pull, push, blame
:Gpull :Gpush :Gblame


