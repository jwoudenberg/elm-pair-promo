autocmd BufWritePost * call ElmPair()
nnoremap - :q!<CR>

" Don't clear screen when exiting Vim (show Vim on last frame of recording).
set t_ti= t_te=

function ElmPair()
  " Save cursor position for restoring it later.
  let save_cursor = getcurpos()

  " Replace contents of buffer with supposed changes by Elm-pair.
  execute "%!./replace.sh"

  " Optional: populate the quickfix list.
  " call setqflist([{'bufnr': bufnr(''), 'pattern': 'Quest'}])

  " Highlight the changes.
  highlight Changes cterm=bold term=bold ctermbg=yellow ctermfg=white
  match Changes /Quest/

  " Restore the cursor position.
  call setpos('.', save_cursor)

  " Redraw the screen now, so the message echoed below won't disappear.
  redraw

  " Elm-pair explains what it did.
  echomsg 'Elm-pair: Renamed "Mission" to "Quest" across 4 files.'
endfunction
