@echo off

set "debug=%~1"

if "%debug%" NEQ "" (
    set "debug=-d %debug%"
)

v -no-skip-unused %debug% -d trace_orm -d trace_orm_stmt -d trace_orm_query -d veb_livereload watch --only-watch=*.v,*.html,*.css,*.js --before "cls" run .