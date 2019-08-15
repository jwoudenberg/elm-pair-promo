autocmd BufWritePre * call ElmPair()

" Use an extra-high command area so the asciinema player chrome won't overlap.
set cmdheight=5

" Open the quickfix window with only as much height as it needs.
au FileType qf call AdjustWindowHeight(3, 10)
function! AdjustWindowHeight(minheight, maxheight)
  exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction

function ElmPair()
  " Save cursor position for restoring it later.
  let save_cursor = getcurpos()

  " Replace contents of buffer with supposed changes by Elm-pair.
  execute "%!./replace.sh"

  " Highlight the changes.
  highlight Changes cterm=bold term=bold ctermbg=yellow ctermfg=black
  call matchadd("Changes", '(Debug.todo "New argument")')
  call matchadd("Changes", '_')

  " Optional: populate the quickfix list.
  call setqflist([{'bufnr': bufnr(''), 'pattern': '(Debug.todo "New argument")'}, {'filename': 'src/Hero.elm', 'pattern': '(Debug.todo "New argument")' }])
  copen

  " Restore the cursor position.
  call setpos('.', save_cursor)

  " Redraw the screen now, so the message echoed below won't disappear.
  redraw

  " Elm-pair explains what it did.
  echomsg 'Elm-pair: I added a placeholder for that new argument of the "difficulty" function in two places.'

  " Quit Vim after two seconds.
  redraw
  sleep 1
  qa!

endfunction
