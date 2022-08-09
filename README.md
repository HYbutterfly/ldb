# ldb
Yet another lua database library (log-persistence)



## Test (推荐在 unix 下进行)
0. 请提前安装 lua 环境 (lua53以上)
1. git clone https://github.com/HYbutterfly/ldb.git hello-ldb
2. 进入 hello-ldb/luaclib-src/serialize build, 将编译出来的 serialize.so 拷到 hello-ldb
3. 进入 hello-ldb 执行 lua main.lua



## Todo
日志文件数据的压缩（重新生成）
添加常量表功能, 以压缩日志数据大小
