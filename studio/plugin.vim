autocmd BufWritePre * call ElmPair()
highlight Changes cterm=bold term=bold ctermbg=yellow ctermfg=black

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

  " Highlight lines that are going to be deleted
  call matchadd("Changes", 'let')
  call matchadd("Changes", '\<in\>')
  redraw
  sleep 500m

  " Replace contents of buffer with supposed changes by Elm-pair.
  execute "%!./replace.sh"

  " Highlight the changes.
  call matchadd("Changes", 'part whole')
  call matchadd("Changes", 'fraction : Float -> Float -> Float')
  call matchadd("Changes", 'fraction part whole = part / whole')

  " " Optional: populate the quickfix list.
  " call setqflist([{'bufnr': bufnr(''), 'pattern': '(Debug.todo "New argument")'}, {'filename': 'src/Hero.elm', 'pattern': '(Debug.todo "New argument")' }])
  " copen

  " Restore the cursor position.
  call setpos('.', save_cursor)

  " Redraw the screen now, so the message echoed below won't disappear.
  redraw

  " Elm-pair explains what it did.
  echomsg 'Elm-pair: I added two arguments to the let binding you moved to the top level.'

  " Quit Vim after two seconds.
  redraw
  sleep 1
  qa!

endfunction
