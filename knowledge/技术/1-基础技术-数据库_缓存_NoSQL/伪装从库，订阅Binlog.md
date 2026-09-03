# 伪装从库，订阅Binlog


mysqlbinlog --read-from-remote-server --host=主库IP地址 --user=用户名 --password=密码 --stop-never --raw --result-file=日志文件名.bin --start-position=主库的Position值 主库的binlog文件名


    Created at: 2023-05-05T09:52:41+08:00
    Updated at: 2023-05-05T09:52:50+08:00

