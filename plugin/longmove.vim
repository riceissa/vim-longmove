if exists("g:loaded_longmove")
  finish
endif
let g:loaded_longmove = 1

if !hasmapto("<Plug>LongmovegH", "n") && "" == mapcheck("gH","n")
  nmap gH <Plug>LongmovegH
endif
if !hasmapto("<Plug>LongmoveVisualgH", "v") && "" == mapcheck("gH","v")
  vmap gH <Plug>LongmoveVisualgH
endif
if !hasmapto("<Plug>LongmovegM", "n") && "" == mapcheck("gM","n")
  nmap gM <Plug>LongmovegM
endif
if !hasmapto("<Plug>LongmoveVisualgM", "v") && "" == mapcheck("gM","v")
  vmap gM <Plug>LongmoveVisualgM
endif
if !hasmapto("<Plug>LongmovegL", "n") && "" == mapcheck("gL","n")
  nmap gL <Plug>LongmovegL
endif
if !hasmapto("<Plug>LongmoveVisualgL", "v") && "" == mapcheck("gL","v")
  vmap gL <Plug>LongmoveVisualgL
endif

nnoremap <silent> <script> <Plug>LongmovegH :<C-U>call <SID>gH("")<CR>
vnoremap <silent> <script> <Plug>LongmoveVisualgH :<C-U>call <SID>gH("gv")<CR>
nnoremap <silent> <script> <Plug>LongmovegM :<C-U>call <SID>gM("")<CR>
vnoremap <silent> <script> <Plug>LongmoveVisualgM :<C-U>call <SID>gM("gv")<CR>
nnoremap <silent> <script> <Plug>LongmovegL :<C-U>call <SID>gL("")<CR>
vnoremap <silent> <script> <Plug>LongmoveVisualgL :<C-U>call <SID>gL("gv")<CR>

function! s:gH(vis)
  let l:amt = winline() - 1 - &scrolloff
  let l:c = v:count - 1 - &scrolloff
  let l:c_max = winheight(0) - 2 * &scrolloff - 1
  let l:cmd = "normal! " . a:vis
  " If the count is too large, keep cursor inside the window. This better
  " emulates the behavior of H, e.g. 800H keeps the cursor in the window
  " without scrolling.
  if l:c > l:c_max
    let l:c = l:c_max
  endif
  if l:amt > 0
    " exe "normal! " . a:vis . l:amt . 'gk'
    let l:cmd .= l:amt . 'gk'
  endif
  if l:c > 0
    " exe "normal! " . a:vis . l:c . 'gj'
    let l:cmd .= l:c . 'gj'
  endif
  if &startofline
    " exe "normal! " . a:vis . 'g^'
    let l:cmd .= 'g^'
  endif
  exe l:cmd
endfunction

function! s:gL(vis)
  let l:amt = winheight(0) - winline() - &scrolloff
  let l:c = v:count - 1 - &scrolloff
  let l:c_max = winheight(0) - 2 * &scrolloff - 1
  let l:cmd = "normal! " . a:vis
  if l:c > l:c_max
    let l:c = l:c_max
  endif
  if l:amt > 0
    " exe ':normal! ' . l:amt . 'gj'
    let l:cmd .= l:amt . 'gj'
  endif
  if l:c > 0
    " exe ':normal! ' . l:c . 'gk'
    let l:cmd .= l:c . 'gk'
  endif
  if &startofline
    " exe ':normal! g^'
    let l:cmd .= 'g^'
  endif
  exe l:cmd
endfunction

function! s:gM(vis)
  let l:amt = (winheight(0)+1)/2 - winline()
  let l:cmd = "normal! " . a:vis
  if l:amt > 0
    " Cursor is in the top half of window so go down.
    " exe ':normal! ' . abs(l:amt) . 'gj'
    let l:cmd .= abs(l:amt) . 'gj'
  elseif l:amt < 0
    " Cursor is in the bottom half of window so go down.
    " exe ':normal! ' . abs(l:amt) . 'gk'
    let l:cmd .= abs(l:amt) . 'gk'
  endif
  if &startofline
    " exe ':normal! g^'
    let l:cmd .= 'g^'
  endif
  exe l:cmd
endfunction
