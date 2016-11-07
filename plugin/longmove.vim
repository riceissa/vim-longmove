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
if !hasmapto("<Plug>LongmovegL", "n") && "" == mapcheck("gL","n")
  nmap gL <Plug>LongmovegL
endif

nnoremap <silent> <script> <Plug>LongmovegH :<C-U>call <SID>gH(0)<CR>
vnoremap <silent> <script> <Plug>LongmoveVisualgH :<C-U>call <SID>gH(1)<CR>
nnoremap <silent> <script> <Plug>LongmovegM :<C-U>call <SID>gM()<CR>
nnoremap <silent> <script> <Plug>LongmovegL :<C-U>call <SID>gL()<CR>

function! s:gH(vis)
  if a:vis
    let a:vis = "gv"
  else
    let a:vis = ""
  endif
  let l:amt = winline() - 1 - &scrolloff
  let l:c = v:count - 1 - &scrolloff
  let l:c_max = winheight(0) - 2 * &scrolloff - 1
  " If the count is too large, keep cursor inside the window. This better
  " emulates the behavior of H, e.g. 800H keeps the cursor in the window
  " without scrolling.
  if l:c > l:c_max
    let l:c = l:c_max
  endif
  if l:amt > 0
    exe ':normal! ' . a:vis . l:amt . 'gk'
  endif
  if l:c > 0
    exe ':normal! ' . a:vis . l:c . 'gj'
  endif
  if &startofline
    exe ':normal! ' . a:vis . 'g^'
  endif
endfunction

function! s:gL()
  let l:amt = winheight(0) - winline() - &scrolloff
  let l:c = v:count - 1 - &scrolloff
  let l:c_max = winheight(0) - 2 * &scrolloff - 1
  if l:c > l:c_max
    let l:c = l:c_max
  endif
  if l:amt > 0
    exe ':normal! ' . l:amt . 'gj'
  endif
  if l:c > 0
    exe ':normal! ' . l:c . 'gk'
  endif
  if &startofline
    exe ':normal! g^'
  endif
endfunction

function! s:gM()
  let l:amt = (winheight(0)+1)/2 - winline()
  if l:amt > 0
    " Cursor is in the top half of window so go down.
    exe ':normal! ' . abs(l:amt) . 'gj'
  elseif l:amt < 0
    " Cursor is in the bottom half of window so go down.
    exe ':normal! ' . abs(l:amt) . 'gk'
  endif
  if &startofline
    exe ':normal! g^'
  endif
endfunction
