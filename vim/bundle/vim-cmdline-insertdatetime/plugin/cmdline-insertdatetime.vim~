" cmdline-insertdatetime..vim:
" Load Once:
if &cp || exists("g:loaded_cmdline_insertdatetime")
    finish
endif
let g:loaded_cmdline_insertdatetime = 1
let s:keepcpo = &cpo
set cpo&vim
" ---------------------------------------------------------------------

function! s:InsertCmdDate(format)
    let l:loc = strpart(getcmdline(), 0, getcmdpos() - 1)
    let l:roc = strpart(getcmdline(), getcmdpos() - 1)
    let l:date = strftime(a:format)
    call setcmdpos(strlen(l:loc) + strlen(l:date) + 1)
    return l:loc. l:date. l:roc
endfunction

cmap <C-X>dt <C-\>e<SID>InsertCmdDate('%Y%m%d')<CR>
cmap <C-X>ts <C-\>e<SID>InsertCmdDate('%Y%m%d%H%M')<CR>

" ---------------------------------------------------------------------
let &cpo= s:keepcpo
unlet s:keepcpo

