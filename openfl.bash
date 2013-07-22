_openfl()
{
    local -a commands=("setup" "help" "clean" "update" "build" "run" "test" "display" "create" "rebuild")
    local -a platforms=("android" "blackberry" "emscripten" "flash" "html5" "ios" "linux" "mac" "webos" "windows")
    local -a options=()

    local -a generic_options=("-D" "-debug" "-verbose" "-clean" "-xml")
    local -A context_options=()
            
    context_options[windows]="-neko" 
    context_options[linux]="-neko -64" 
    context_options[mac]="-neko" 
    context_options[android]="-arm7 -arm7-only" 
    context_options[ios]="-simulator -ipad" 
    context_options[blackberry]="-simulator" 
    context_options[html5]="-minify -yui" 
    context_options[display]="-hxml -nmml" 
    context_options[run]="-args" 
    context_options[test]="-args"

    #
    # TODO: Verify that the -arm7 and -arm7-only is valid, because it might be -armv7 and not -arm7
    #

    local curr="${COMP_WORDS[COMP_CWORD]}"
    local prev="${COMP_WORDS[COMP_CWORD - 1]}"
    local list=""

    if [[ ${curr} == -* ]] ; then
        options=${generic_options[@]}
        for context in "${platforms[@]} ${commands[@]}"
        do
            case "${COMP_WORDS[@]}" in 
                *"${context}"*) 
                    options+=" ${context_options[$context]}"
                    ;; 
            esac
        done
        list=$options
    else
        case "${prev}" in 
            (openfl)
                list=${commands[@]}
                ;;

            (setup)
                list=${platforms[@]} 
                ;;

            (create)
                local samples_path=$(haxelib path openfl-samples)
                local sample_names=$(find ${samples_path%/*} -maxdepth 1 -mindepth 1 -type d -printf ' %f')
                list="project extension ${sample_names}" 
                ;;

            (rebuild)
                list=$(find . -maxdepth 1 -mindepth 1 -type d -printf ' %f') 
                ;;

            (clean|update|build|run|test|display)
                list=$(find . -maxdepth 1 -mindepth 1 -type f \( -name "*.xml" -o -name "*.nmml" \) -printf ' %f')
                list=${list:1}
                ;;

            (*)
                prev="${COMP_WORDS[COMP_CWORD - 2]}"
                case "${prev}" in 
                    (clean|update|build|run|test|display|rebuild)
                        list=${platforms[@]}
                        ;;
                esac
                ;;
        esac
    fi

    COMPREPLY=($(compgen -W "${list}" -- ${curr}))
    return 0
}

complete -F _openfl openfl
