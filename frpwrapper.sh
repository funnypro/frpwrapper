#!/bin/sh


#觉得怪异吧？我也这么认为
#然而有些 sh 真的没有 [[
#我也是醉了
type '[[' >/dev/null 2>&1 || alias '[['='['
type '[[' >/dev/null 2>&1 || exit 1

while getopts 'f:o:' OPT; do
    case "${OPT}" in
    f)
        frp_execute_file="${OPTARG}"
    ;;
    o)
        frp_options="${OPTARG}"
    ;;
    *)
        echo "${0##*/}" '<-f <frp execute file>> <-o <frp options>>'
        exit 1
    ;;
    esac
done


[[ -z "${frp_execute_file}" ]] && echo "${0##*/}" '<-f <frp execute file>> <-o <frp options>>' && exit 1

#不要问我为什么这里这么怪异，我的建议是问 sh
#为了 sh 做出的牺牲
[[ ! -s "${frp_execute_file}" ]] && echo "frp execute file invalid" && exit 1
[[ ! -r "${frp_execute_file}" ]] && echo "frp execute file invalid" && exit 1
[[ ! -x "${frp_execute_file}" ]] && echo "frp execute file invalid" && exit 1


[[ -z "${frp_options}" ]] && exit 1 ||  eval "${frp_execute_file}" "${frp_options}" | cut -d ' ' -f 3-
