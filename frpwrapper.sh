#!/bin/sh


#觉得怪异吧？我也这么认为
#然而有些 sh 真的没有 [[
#我也是醉了
type '[[' >/dev/null 2>&1 || alias '[['='['
type '[[' >/dev/null 2>&1 || exit 1

while getopts 'f:c:o:' OPT; do
    case "${OPT}" in
    f)
        frp_execute_file="${OPTARG}"
    ;;
    c)
        frp_config_file="${OPTARG}"
    ;;
    o)
        frp_options="${OPTARG}"
    ;;
    *)
        echo "${0##*/}" '<-f <frp execute file>> <-c <frp config>|-o <frp options>>'
        exit 1
    ;;
    esac
done


#不要问我为什么这里这么怪异，我的建议是问 sh
#为了在路由器上直接使用做出的牺牲
[[ ! -s "${frp_execute_file}" ]] && echo "frp execute file invalid" && exit 1
[[ ! -r "${frp_execute_file}" ]] && echo "frp execute file invalid" && exit 1
[[ ! -x "${frp_execute_file}" ]] && echo "frp execute file invalid" && exit 1


[[ -z "${frp_config_file}" ]] && exec "${frp_execute_file}" "${frp_options}" | cut -d ' ' -f 3-
[[ -z "${frp_options}" ]] && exec "${frp_execute_file}" '-c' "${frp_config_file}" | cut -d ' ' -f 3-

