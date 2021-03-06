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
if !hasmapto("<Plug>LongmoveVisualgH", "o") && "" == mapcheck("gH","o")
  omap gH <Plug>LongmoveOperatorgH
endif

if !hasmapto("<Plug>LongmovegM", "n") && "" == mapcheck("gM","n")
  nmap gM <Plug>LongmovegM
endif
if !hasmapto("<Plug>LongmoveVisualgM", "v") && "" == mapcheck("gM","v")
  vmap gM <Plug>LongmoveVisualgM
endif
if !hasmapto("<Plug>LongmoveVisualgM", "o") && "" == mapcheck("gM","o")
  omap gM <Plug>LongmoveOperatorgM
endif

if !hasmapto("<Plug>LongmovegL", "n") && "" == mapcheck("gL","n")
  nmap gL <Plug>LongmovegL
endif
if !hasmapto("<Plug>LongmoveVisualgL", "v") && "" == mapcheck("gL","v")
  vmap gL <Plug>LongmoveVisualgL
endif
if !hasmapto("<Plug>LongmoveVisualgL", "o") && "" == mapcheck("gL","o")
  omap gL <Plug>LongmoveOperatorgL
endif

nnoremap <silent> <script> <Plug>LongmovegH :<C-U>call <SID>gH(v:count,"")<CR>
vnoremap <silent> <script> <Plug>LongmoveVisualgH :<C-U>call <SID>gH(v:count,"gv")<CR>
" omap <silent> <script> <Plug>LongmoveOperatorgH :<C-U>normal VgH<CR>
onoremap <silent> <script> <Plug>LongmoveOperatorgH :<C-U>call <SID>gH(v:count,"")<CR>

nnoremap <silent> <script> <Plug>LongmovegM :<C-U>call <SID>gM("")<CR>
vnoremap <silent> <script> <Plug>LongmoveVisualgM :<C-U>call <SID>gM("gv")<CR>
onoremap <silent> <script> <Plug>LongmoveOperatorgM :<C-U>call <SID>gM("")<CR>

nnoremap <silent> <script> <Plug>LongmovegL :<C-U>call <SID>gL(v:count,"")<CR>
vnoremap <silent> <script> <Plug>LongmoveVisualgL :<C-U>call <SID>gL(v:count,"gv")<CR>
onoremap <silent> <script> <Plug>LongmoveOperatorgL :<C-U>call <SID>gL(v:count,"")<CR>

function! s:gH(count, vis)
  if a:vis ==# "gv"
    " When you run :normal!, Vim changes winline() to the cursor position at
    " the start of the visual selection. This is different from the actual
    " current cursor position if the actual cursor position was at the end of
    " the visual selection. You can verify this by entering visual mode,
    " moving to a different visual line, then typing
    "     :<C-U>echom winline()<CR>
    " Since Vim doesn't seem to provide a function to get the window line of
    " the current cursor position, the only workaround I know of is to call gv
    " to reselect the visual area and immediately check winline() in the same
    " line. Compare the above with the result of typing
    "     :<C-U>exe 'normal! gv' | echom winline()<CR>
    exe "normal! " . a:vis | let l:amt = winline() - 1 - &scrolloff
  else
    let l:amt = winline() - 1 - &scrolloff
  endif
  let l:c = a:count - 1 - &scrolloff
  let l:c_max = winheight(0) - 2 * &scrolloff - 1
  let l:cmd = "normal! " . a:vis
  " If the count is too large, keep cursor inside the window. This better
  " emulates the behavior of H, e.g. 800H keeps the cursor in the window
  " without scrolling.
  if l:c > l:c_max
    let l:c = l:c_max
  endif
  if l:amt > 0
    let l:cmd .= l:amt . 'gk'
  endif
  if l:c > 0
    let l:cmd .= l:c . 'gj'
  endif
  if &startofline
    let l:cmd .= 'g^'
  endif
  exe l:cmd
endfunction

function! s:gL(count, vis)
  if a:vis ==# "gv"
    exe "normal! " . a:vis | let l:amt = winheight(0) - winline() - &scrolloff
  else
    let l:amt = winheight(0) - winline() - &scrolloff
  endif
  let l:c = a:count - 1 - &scrolloff
  let l:c_max = winheight(0) - 2 * &scrolloff - 1
  let l:cmd = "normal! " . a:vis
  if l:c > l:c_max
    let l:c = l:c_max
  endif
  if l:amt > 0
    let l:cmd .= l:amt . 'gj'
  endif
  if l:c > 0
    let l:cmd .= l:c . 'gk'
  endif
  if &startofline
    let l:cmd .= 'g^'
  endif
  exe l:cmd
endfunction

function! s:gM(vis)
  if a:vis ==# "gv"
    exe "normal! " . a:vis | let l:amt = (winheight(0)+1)/2 - winline()
  else
    let l:amt = (winheight(0)+1)/2 - winline()
  endif
  let l:cmd = "normal! " . a:vis
  if l:amt > 0
    " Cursor is in the top half of window so go down.
    let l:cmd .= abs(l:amt) . 'gj'
  elseif l:amt < 0
    " Cursor is in the bottom half of window so go down.
    let l:cmd .= abs(l:amt) . 'gk'
  endif
  if &startofline
    let l:cmd .= 'g^'
  endif
  exe l:cmd
endfunction
