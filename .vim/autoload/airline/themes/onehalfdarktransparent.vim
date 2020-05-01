" Transparency-compatible theme based on onehalfdark
" https://github.com/sonph/onehalf/blob/master/vim/autoload/airline/themes/onehalfdark.vim

" _g: gui, _c: cterm
let s:light_g = '#dcdfe4'
let s:light_c = 255
let s:med_hi_g = '#5d677a'
let s:med_hi_c = 243
let s:med_lo_g = '#313640'
let s:med_lo_c = 238
let s:dark_g = '#282c34'
let s:dark_c = 236
let s:transparent = 'NONE'

let s:green_g = '#98c379'
let s:green_c = 114
let s:blue_g = '#61afef'
let s:blue_c = 75
let s:yellow_g = '#e5c07b'
let s:yellow_c = 180
let s:red_g = '#e06c75'
let s:red_c = 168


let g:airline#themes#onehalfdarktransparent#palette = {}


" Normal mode
" Array format: [guifg, guibg, ctermfg, ctermbg, opts]
let s:normal_outer = [s:dark_g, s:green_g, s:dark_c, s:green_c]
let s:normal_middle = [s:light_g, s:med_hi_g, s:light_c, s:med_hi_c]
let s:normal_inner = [s:green_g, s:transparent, s:green_c, s:med_hi_c]
let s:normal_inner_modified = [s:yellow_g, s:med_lo_g, s:yellow_c, s:med_lo_c]
let g:airline#themes#onehalfdarktransparent#palette.normal = 
    \ airline#themes#generate_color_map(s:normal_outer, s:normal_middle, s:normal_inner)
let g:airline#themes#onehalfdarktransparent#palette.normal_modified =
    \ airline#themes#generate_color_map(s:normal_outer, s:normal_middle, s:normal_inner_modified)


" Insert mode
let s:insert_outer = [s:med_lo_g, s:blue_g, s:med_lo_c, s:blue_c]
let s:insert_middle = s:normal_middle
let s:insert_inner = [s:blue_g, s:transparent, s:blue_c, s:med_hi_c]
let g:airline#themes#onehalfdarktransparent#palette.insert = 
    \ airline#themes#generate_color_map(s:insert_outer, s:insert_middle, s:insert_inner)
let g:airline#themes#onehalfdarktransparent#palette.insert_modified = 
    \ copy(g:airline#themes#onehalfdarktransparent#palette.normal_modified)


" Replace mode
let s:replace_outer = [s:med_lo_g, s:red_g, s:med_lo_c, s:red_c]
let s:replace_middle = s:normal_middle
let s:replace_inner = [s:red_g, s:transparent, s:red_c, s:med_hi_c]
let g:airline#themes#onehalfdarktransparent#palette.replace =
    \ airline#themes#generate_color_map(s:replace_outer, s:replace_middle, s:replace_inner)
let g:airline#themes#onehalfdarktransparent#palette.replace_modified = 
    \ copy(g:airline#themes#onehalfdarktransparent#palette.insert_modified)


" Visual mode
let s:visual_outer = [s:dark_g, s:yellow_g, s:dark_c, s:yellow_c]
let s:visual_middle = s:normal_middle
let s:visual_inner = [s:yellow_g, s:transparent, s:yellow_c, s:med_hi_c]
let g:airline#themes#onehalfdarktransparent#palette.visual = 
    \ airline#themes#generate_color_map(s:visual_outer, s:visual_middle, s:visual_inner)
let g:airline#themes#onehalfdarktransparent#palette.visual_modified = 
    \ copy(g:airline#themes#onehalfdarktransparent#palette.insert_modified)


" Inactive window
let s:inactive = [s:light_g, s:med_lo_g, s:light_c, s:med_lo_c]
let s:inactive_modified = [s:yellow_g, '', s:yellow_c, '']
let g:airline#themes#onehalfdarktransparent#palette.inactive = 
    \ airline#themes#generate_color_map(s:inactive, s:inactive, s:inactive)
let g:airline#themes#onehalfdarktransparent#palette.inactive_modified = 
    \ airline#themes#generate_color_map(s:inactive, s:inactive, s:inactive_modified)
