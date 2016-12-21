module Redis{

    use SysBasic;

    require "hiredis/hiredis.h";
    require "time.h";

extern record redisReadTask{
}

extern record redisReplyObjectFunctions{
}

extern record redisReader{
}

extern proc  redisReaderCreateWithFunctions(fn: c_ptr(redisReplyObjectFunctions ) ):c_ptr(redisReader );
extern proc  redisReaderFree(r: c_ptr(redisReader ) ):c_void_ptr;
extern proc  redisReaderFeed(r: c_ptr(redisReader ), buf: c_string, len: c_int ):c_int;
extern proc  redisReaderGetReply(r: c_ptr(redisReader ), reply: c_ptr(void ) ):c_int;

extern record redisReply{
    var _type: c_int;
	var integer: c_longlong;
	var len: c_int;
	var str: c_string;
	var elements: c_int;
	var element: c_ptr(redisReply );
}

extern record redisContext{
}

extern record sds{
}
extern "struct timeval" record timeval{

}


extern proc  redisReaderCreate():c_ptr(redisReader );
extern proc  freeReplyObject(reply: c_void_ptr ):c_void_ptr;
extern proc  redisvFormatCommand(target: c_string, format: c_string, ap...?k ):c_int;
extern proc  redisFormatCommand(target: c_string, format: c_string ):c_int;
extern proc  redisFormatCommandArgv(target: c_string, argc: c_int, argv: c_string, argvlen: c_ptr(c_int ) ):c_int;
extern proc  redisFormatSdsCommandArgv(target: c_ptr(sds ), argc: c_int, argv: c_string, argvlen: c_ptr(c_int ) ):c_int;
extern proc  redisFreeCommand(cmd: c_ptr(c_char) ):c_void_ptr;
extern proc  redisFreeSdsCommand(cmd: sds ):c_void_ptr;

extern proc  redisConnect(ip: c_string, port: c_int ):c_ptr(redisContext );
extern proc  redisConnectWithTimeout(ip: c_string, port: c_int, tv: timeval ):c_ptr(redisContext );
extern proc  redisConnectNonBlock(ip: c_string, port: c_int ):c_ptr(redisContext );
extern proc  redisConnectBindNonBlock(ip: c_string, port: c_int, source_addr: c_string ):c_ptr(redisContext );
extern proc  redisConnectBindNonBlockWithReuse(ip: c_string, port: c_int, source_addr: c_string ):c_ptr(redisContext );
extern proc  redisConnectUnix(path: c_string ):c_ptr(redisContext );
extern proc  redisConnectUnixWithTimeout(path: c_string, tv: timeval ):c_ptr(redisContext );
extern proc  redisConnectUnixNonBlock(path: c_string ):c_ptr(redisContext );
extern proc  redisConnectFd(fd: c_int ):c_ptr(redisContext );
extern proc  redisReconnect(c: c_ptr(redisContext ) ):c_int;
extern proc  redisSetTimeout(c: c_ptr(redisContext ), tv: timeval ):c_int;
extern proc  redisEnableKeepAlive(c: c_ptr(redisContext ) ):c_int;
extern proc  redisFree(c: c_ptr(redisContext ) ):c_void_ptr;
extern proc  redisFreeKeepFd(c: c_ptr(redisContext ) ):c_int;
extern proc  redisBufferRead(c: c_ptr(redisContext ) ):c_int;
extern proc  redisBufferWrite(c: c_ptr(redisContext ), done: c_ptr(c_int) ):c_int;
extern proc  redisGetReply(c: c_ptr(redisContext ), reply: c_ptr(void ) ):c_int;
extern proc  redisGetReplyFromReader(c: c_ptr(redisContext ), reply: c_ptr(void ) ):c_int;
extern proc  redisAppendFormattedCommand(c: c_ptr(redisContext ), cmd: c_string, len: c_int ):c_int;
extern proc  redisvAppendCommand(c: c_ptr(redisContext ), format: c_string, ap...?k ):c_int;
extern proc  redisAppendCommand(c: c_ptr(redisContext ), format: c_string ):c_int;
extern proc  redisAppendCommandArgv(c: c_ptr(redisContext ), argc: c_int, argv: c_string, argvlen: c_ptr(c_int ) ):c_int;
extern proc  redisvCommand(c: c_ptr(redisContext ), format: c_string, ap...?k ):c_void_ptr;
extern proc  redisCommand(c: c_ptr(redisContext ), format: c_string ):c_void_ptr;
extern proc  redisCommandArgv(c: c_ptr(redisContext ), argc: c_int, argv: c_string, argvlen: c_ptr(c_int ) ):c_void_ptr;




}