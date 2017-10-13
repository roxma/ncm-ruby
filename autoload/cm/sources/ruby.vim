
func! cm#sources#ruby#register()
    " the omnifunc pattern is PCRE
    call cm#register_source({'name' : 'ruby',
            \ 'priority': 9, 
            \ 'scopes': ['ruby'],
            \ 'abbreviation': 'rb',
            \ 'cm_refresh_patterns':['\.', '::'],
            \ 'cm_refresh': 'cm#sources#ruby#refresh',
            \ })

    let g:rubycomplete_completions = []

ruby << RUBYEOF
def cm_refresh
    ctx = VIM::evaluate('g:cm#sources#ruby#ctx')
    base = ctx['base']
    VimRubyCompletion.get_completions base
    VIM::evaluate "cm#sources#ruby#complete()"
end
RUBYEOF
endfunc

let g:cm#sources#ruby#ctx = {}
let g:cm#sources#ruby#result = {}

func! cm#sources#ruby#refresh(info, ctx)
    let startcol = rubycomplete#Complete(1, '') + 1
    let base = getline('.')[startcol-1: col('.') - 2]
    let g:cm#sources#ruby#ctx['info'] = a:info
    let g:cm#sources#ruby#ctx['startcol'] = startcol
    let g:cm#sources#ruby#ctx['base'] = base
    let g:cm#sources#ruby#ctx['ctx'] = a:ctx
    let g:rubycomplete_completions = []
    call ascript#ruby('cm_refresh')
endfunc

func! cm#sources#ruby#complete()
    let ctx = g:cm#sources#ruby#ctx['ctx']
    let info = g:cm#sources#ruby#ctx['info']
    let startcol = g:cm#sources#ruby#ctx['startcol']
    call cm#complete(info, ctx, startcol, g:rubycomplete_completions)
endfunc

