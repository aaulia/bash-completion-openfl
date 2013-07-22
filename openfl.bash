_openfl()
{
    local cmds="setup help clean update build run test display create rebuild"
    local tgts="android blackberry emscripten flash html5 ios linux mac webos windows"
    local opts="-D -debug -verbose -clean -xml -neko -64 -hxml -nmml -simulator -ipad -minify -yui -args -arm7 -arm7-only"

    #
    # TODO: Verify that the -arm7 and -arm7-only is valid, because it might be -armv7 and not -arm7
    #

    local curr="${COMP_WORDS[COMP_CWORD]}"
    local prev="${COMP_WORDS[COMP_CWORD - 1]}"
    local list=""

    if [[ ${curr} == -* ]] ; then
        list=$opts
    else
        case "${prev}" in 
            (openfl)
                list=$cmds 
                ;;

            (setup)
                list=$tgts 
                ;;

            (create)
                local samples_path=$(haxelib path openfl-samples)
                local sample_names=$(find ${samples_path%/*} -maxdepth 1 -mindepth 1 -type d -printf ' %f')
                list="project extension ${sample_names}" 
                ;;

            (rebuild)
                list=$(find . -maxdepth 1 -mindepth 1 -type d -printf ' %f') 
                ;;

            (*)
                prev="${COMP_WORDS[COMP_CWORD - 2]}"
                case "${prev}" in 
                    (clean|update|build|run|test|display|rebuild)
                        list=$tgts
                        ;;
                esac
                ;;
        esac
    fi

    COMPREPLY=($(compgen -W "${list}" -- ${curr}))
    return 0
}

complete -F _openfl openfl
