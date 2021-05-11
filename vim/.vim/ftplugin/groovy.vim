" Use the same formatoptions as Java. The main advantage is that multiline
" comments are properly prefixed with an asterisk.
setlocal formatoptions=croql

" TODO: make this smarter; have it search for the nearest `.git/` directory
" and use that as the root for the source paths.
command! GrailsJDB call vebugger#jdb#attach('5005', {
			\ 'srcpath': [
			\   './grails-app/controllers',
			\   './grails-app/domain',
			\   './grails-app/jobs',
			\   './grails-app/services',
			\   './grails-app/taglib',
			\ ]
			\ })
