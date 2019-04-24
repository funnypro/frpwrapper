#!/bin/sh /etc/rc.common



START=50
STOP=50


CONFFILE=/etc/frp/frpc.ini
PROG=/usr/bin/frpwrapper
FRPFILE=/usr/bin/frpc


start_service(){
    procd_open_instance frpc
    procd_set_param command "${PROG}" -f "${FRPFILE}" -o "-c ${CONFFILE}"
    procd_set_param file "${CONFFILE}"
    procd_set_param user nobody # 无法绑定前 1024 端口
    #procd_set_param user root # 使用 root 可能会导致安全问题，不过可以使用前 1024 端口
    procd_set_param respawn

    procd_set_param watch network.interface
    procd_set_param netdev dev
    procd_set_param stdout 1
    procd_set_param stderr 1
    procd_close_instance
}

stop_service(){
    killall frpc # 克服 procd 没有类似 systemd 的 KillMode= 选项导致停止服务只是结束脚本的情况（然而这个方法会造成误伤
}

reload_service(){
    # 比较懒，所以没用重载
    # 一部分原因是要查配置文件，然后不太会
    # "${PROG}" -f "${FRPFILE}" -o "reload -c ${CONFFILE}"
    restart
}
