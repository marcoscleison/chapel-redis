/*
 * Copyright (C) 2016 Marcos Cleison Silva Santana
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
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

class Redis{
	var con:c_ptr(redisContext );

	proc Redis(host:string="127.0.0.1",port:int=6379){
		      this.con =  redisConnect(host.localize().c_str(),  port);
        var reply = redisCommand(con,"PING".localize().c_str()):c_ptr(redisReply);
        var r = reply.deref();
        var s= new string(r.str);
        writeln(s);
	}

	proc Command(format: string){
		return redisCommand(con,format.localize().c_str()):c_ptr(redisReply);
	}
	proc Pfadd(args){
  	 return this.Command("PFADD");
  } 

proc Pfcount(args){
  	 return this.Command("PFCOUNT");
  } 

proc Pfmerge(args){
  	 return this.Command("PFMERGE");
  } 

proc Hdel(args){
  	 return this.Command("HDEL");
  } 

proc Hexists(args){
  	 return this.Command("HEXISTS");
  } 

proc Hget(args){
  	 return this.Command("HGET");
  } 

proc Hgetall(args){
  	 return this.Command("HGETALL");
  } 

proc Hincrby(args){
  	 return this.Command("HINCRBY");
  } 

proc Hincrbyfloat(args){
  	 return this.Command("HINCRBYFLOAT");
  } 

proc Hkeys(args){
  	 return this.Command("HKEYS");
  } 

proc Hlen(args){
  	 return this.Command("HLEN");
  } 

proc Hmget(args){
  	 return this.Command("HMGET");
  } 

proc Hmset(args){
  	 return this.Command("HMSET");
  } 

proc Hscan(args){
  	 return this.Command("HSCAN");
  } 

proc Hset(args){
  	 return this.Command("HSET");
  } 

proc Hsetnx(args){
  	 return this.Command("HSETNX");
  } 

proc Hstrlen(args){
  	 return this.Command("HSTRLEN");
  } 

proc Hvals(args){
  	 return this.Command("HVALS");
  } 

proc Geoadd(args){
  	 return this.Command("GEOADD");
  } 

proc Geodist(args){
  	 return this.Command("GEODIST");
  } 

proc Geohash(args){
  	 return this.Command("GEOHASH");
  } 

proc Geopos(args){
  	 return this.Command("GEOPOS");
  } 

proc Georadius(args){
  	 return this.Command("GEORADIUS");
  } 

proc Georadiusbymember(args){
  	 return this.Command("GEORADIUSBYMEMBER");
  } 

proc Auth(args){
  	 return this.Command("AUTH");
  } 

proc Echo(args){
  	 return this.Command("ECHO");
  } 

proc Ping(args){
  	 return this.Command("PING");
  } 

proc Quit(args){
  	 return this.Command("QUIT");
  } 

proc Select(args){
  	 return this.Command("SELECT");
  } 

proc Swapdb(args){
  	 return this.Command("SWAPDB");
  } 

proc ClusterAddslots(args){
  	 return this.Command("CLUSTER ADDSLOTS");
  } 

proc ClusterCountFailureReports(args){
  	 return this.Command("CLUSTER COUNT-FAILURE-REPORTS");
  } 

proc ClusterCountkeysinslot(args){
  	 return this.Command("CLUSTER COUNTKEYSINSLOT");
  } 

proc ClusterDelslots(args){
  	 return this.Command("CLUSTER DELSLOTS");
  } 

proc ClusterFailover(args){
  	 return this.Command("CLUSTER FAILOVER");
  } 

proc ClusterForget(args){
  	 return this.Command("CLUSTER FORGET");
  } 

proc ClusterGetkeysinslot(args){
  	 return this.Command("CLUSTER GETKEYSINSLOT");
  } 

proc ClusterInfo(args){
  	 return this.Command("CLUSTER INFO");
  } 

proc ClusterKeyslot(args){
  	 return this.Command("CLUSTER KEYSLOT");
  } 

proc ClusterMeet(args){
  	 return this.Command("CLUSTER MEET");
  } 

proc ClusterNodes(args){
  	 return this.Command("CLUSTER NODES");
  } 

proc ClusterReplicate(args){
  	 return this.Command("CLUSTER REPLICATE");
  } 

proc ClusterReset(args){
  	 return this.Command("CLUSTER RESET");
  } 

proc ClusterSaveconfig(args){
  	 return this.Command("CLUSTER SAVECONFIG");
  } 

proc ClusterSet-Config-Epoch(args){
  	 return this.Command("CLUSTER SET-CONFIG-EPOCH");
  } 

proc ClusterSetslot(args){
  	 return this.Command("CLUSTER SETSLOT");
  } 

proc ClusterSlaves(args){
  	 return this.Command("CLUSTER SLAVES");
  } 

proc ClusterSlots(args){
  	 return this.Command("CLUSTER SLOTS");
  } 

proc Readonly(args){
  	 return this.Command("READONLY");
  } 

proc Readwrite(args){
  	 return this.Command("READWRITE");
  } 

proc Del(args){
  	 return this.Command("DEL");
  } 

proc Dump(args){
  	 return this.Command("DUMP");
  } 

proc Exists(args){
  	 return this.Command("EXISTS");
  } 

proc Expire(args){
  	 return this.Command("EXPIRE");
  } 

proc Expireat(args){
  	 return this.Command("EXPIREAT");
  } 

proc Keys(args){
  	 return this.Command("KEYS");
  } 

proc Migrate(args){
  	 return this.Command("MIGRATE");
  } 

proc Move(args){
  	 return this.Command("MOVE");
  } 

proc Object(args){
  	 return this.Command("OBJECT");
  } 

proc Persist(args){
  	 return this.Command("PERSIST");
  } 

proc Pexpire(args){
  	 return this.Command("PEXPIRE");
  } 

proc Pexpireat(args){
  	 return this.Command("PEXPIREAT");
  } 

proc Pttl(args){
  	 return this.Command("PTTL");
  } 

proc Randomkey(args){
  	 return this.Command("RANDOMKEY");
  } 

proc Rename(args){
  	 return this.Command("RENAME");
  } 

proc Renamenx(args){
  	 return this.Command("RENAMENX");
  } 

proc Restore(args){
  	 return this.Command("RESTORE");
  } 

proc Scan(args){
  	 return this.Command("SCAN");
  } 

proc Sort(args){
  	 return this.Command("SORT");
  } 

proc Touch(args){
  	 return this.Command("TOUCH");
  } 

proc Ttl(args){
  	 return this.Command("TTL");
  } 

proc Type(args){
  	 return this.Command("TYPE");
  } 

proc Unlink(args){
  	 return this.Command("UNLINK");
  } 

proc Wait(args){
  	 return this.Command("WAIT");
  } 

proc Blpop(args){
  	 return this.Command("BLPOP");
  } 

proc Brpop(args){
  	 return this.Command("BRPOP");
  } 

proc Brpoplpush(args){
  	 return this.Command("BRPOPLPUSH");
  } 

proc Lindex(args){
  	 return this.Command("LINDEX");
  } 

proc Linsert(args){
  	 return this.Command("LINSERT");
  } 

proc Llen(args){
  	 return this.Command("LLEN");
  } 

proc Lpop(args){
  	 return this.Command("LPOP");
  } 

proc Lpush(args){
  	 return this.Command("LPUSH");
  } 

proc Lpushx(args){
  	 return this.Command("LPUSHX");
  } 

proc Lrange(args){
  	 return this.Command("LRANGE");
  } 

proc Lrem(args){
  	 return this.Command("LREM");
  } 

proc Lset(args){
  	 return this.Command("LSET");
  } 

proc Ltrim(args){
  	 return this.Command("LTRIM");
  } 

proc Rpop(args){
  	 return this.Command("RPOP");
  } 

proc Rpoplpush(args){
  	 return this.Command("RPOPLPUSH");
  } 

proc Rpush(args){
  	 return this.Command("RPUSH");
  } 

proc Rpushx(args){
  	 return this.Command("RPUSHX");
  } 

proc Psubscribe(args){
  	 return this.Command("PSUBSCRIBE");
  } 

proc Publish(args){
  	 return this.Command("PUBLISH");
  } 

proc Pubsub(args){
  	 return this.Command("PUBSUB");
  } 

proc Punsubscribe(args){
  	 return this.Command("PUNSUBSCRIBE");
  } 

proc Subscribe(args){
  	 return this.Command("SUBSCRIBE");
  } 

proc Unsubscribe(args){
  	 return this.Command("UNSUBSCRIBE");
  } 

proc Eval(args){
  	 return this.Command("EVAL");
  } 

proc Evalsha(args){
  	 return this.Command("EVALSHA");
  } 

proc ScriptDebug(args){
  	 return this.Command("SCRIPT DEBUG");
  } 

proc ScriptExists(args){
  	 return this.Command("SCRIPT EXISTS");
  } 

proc ScriptFlush(args){
  	 return this.Command("SCRIPT FLUSH");
  } 

proc ScriptKill(args){
  	 return this.Command("SCRIPT KILL");
  } 

proc ScriptLoad(args){
  	 return this.Command("SCRIPT LOAD");
  } 

proc Bgrewriteaof(args){
  	 return this.Command("BGREWRITEAOF");
  } 

proc Bgsave(args){
  	 return this.Command("BGSAVE");
  } 

proc ClientGetname(args){
  	 return this.Command("CLIENT GETNAME");
  } 

proc ClientKill(args){
  	 return this.Command("CLIENT KILL");
  } 

proc ClientList(args){
  	 return this.Command("CLIENT LIST");
  } 

proc ClientPause(args){
  	 return this.Command("CLIENT PAUSE");
  } 

proc ClientReply(args){
  	 return this.Command("CLIENT REPLY");
  } 

proc ClientSetname(args){
  	 return this.Command("CLIENT SETNAME");
  } 

proc Command(args){
  	 return this.Command("COMMAND");
  } 

proc CommandCount(args){
  	 return this.Command("COMMAND COUNT");
  } 

proc CommandGetkeys(args){
  	 return this.Command("COMMAND GETKEYS");
  } 

proc CommandInfo(args){
  	 return this.Command("COMMAND INFO");
  } 

proc ConfigGet(args){
  	 return this.Command("CONFIG GET");
  } 

proc ConfigResetstat(args){
  	 return this.Command("CONFIG RESETSTAT");
  } 

proc ConfigRewrite(args){
  	 return this.Command("CONFIG REWRITE");
  } 

proc ConfigSet(args){
  	 return this.Command("CONFIG SET");
  } 

proc Dbsize(args){
  	 return this.Command("DBSIZE");
  } 

proc DebugObject(args){
  	 return this.Command("DEBUG OBJECT");
  } 

proc DebugSegfault(args){
  	 return this.Command("DEBUG SEGFAULT");
  } 

proc Flushall(args){
  	 return this.Command("FLUSHALL");
  } 

proc Flushdb(args){
  	 return this.Command("FLUSHDB");
  } 

proc Info(args){
  	 return this.Command("INFO");
  } 

proc Lastsave(args){
  	 return this.Command("LASTSAVE");
  } 

proc Monitor(args){
  	 return this.Command("MONITOR");
  } 

proc Role(args){
  	 return this.Command("ROLE");
  } 

proc Save(args){
  	 return this.Command("SAVE");
  } 

proc Shutdown(args){
  	 return this.Command("SHUTDOWN");
  } 

proc Slaveof(args){
  	 return this.Command("SLAVEOF");
  } 

proc Slowlog(args){
  	 return this.Command("SLOWLOG");
  } 

proc Sync(args){
  	 return this.Command("SYNC");
  } 

proc Time(args){
  	 return this.Command("TIME");
  } 

proc Sadd(args){
  	 return this.Command("SADD");
  } 

proc Scard(args){
  	 return this.Command("SCARD");
  } 

proc Sdiff(args){
  	 return this.Command("SDIFF");
  } 

proc Sdiffstore(args){
  	 return this.Command("SDIFFSTORE");
  } 

proc Sinter(args){
  	 return this.Command("SINTER");
  } 

proc Sinterstore(args){
  	 return this.Command("SINTERSTORE");
  } 

proc Sismember(args){
  	 return this.Command("SISMEMBER");
  } 

proc Smembers(args){
  	 return this.Command("SMEMBERS");
  } 

proc Smove(args){
  	 return this.Command("SMOVE");
  } 

proc Spop(args){
  	 return this.Command("SPOP");
  } 

proc Srandmember(args){
  	 return this.Command("SRANDMEMBER");
  } 

proc Srem(args){
  	 return this.Command("SREM");
  } 

proc Sscan(args){
  	 return this.Command("SSCAN");
  } 

proc Sunion(args){
  	 return this.Command("SUNION");
  } 

proc Sunionstore(args){
  	 return this.Command("SUNIONSTORE");
  } 

proc Zadd(args){
  	 return this.Command("ZADD");
  } 

proc Zcard(args){
  	 return this.Command("ZCARD");
  } 

proc Zcount(args){
  	 return this.Command("ZCOUNT");
  } 

proc Zincrby(args){
  	 return this.Command("ZINCRBY");
  } 

proc Zinterstore(args){
  	 return this.Command("ZINTERSTORE");
  } 

proc Zlexcount(args){
  	 return this.Command("ZLEXCOUNT");
  } 

proc Zrange(args){
  	 return this.Command("ZRANGE");
  } 

proc Zrangebylex(args){
  	 return this.Command("ZRANGEBYLEX");
  } 

proc Zrangebyscore(args){
  	 return this.Command("ZRANGEBYSCORE");
  } 

proc Zrank(args){
  	 return this.Command("ZRANK");
  } 

proc Zrem(args){
  	 return this.Command("ZREM");
  } 

proc Zremrangebylex(args){
  	 return this.Command("ZREMRANGEBYLEX");
  } 

proc Zremrangebyrank(args){
  	 return this.Command("ZREMRANGEBYRANK");
  } 

proc Zremrangebyscore(args){
  	 return this.Command("ZREMRANGEBYSCORE");
  } 

proc Zrevrange(args){
  	 return this.Command("ZREVRANGE");
  } 

proc Zrevrangebylex(args){
  	 return this.Command("ZREVRANGEBYLEX");
  } 

proc Zrevrangebyscore(args){
  	 return this.Command("ZREVRANGEBYSCORE");
  } 

proc Zrevrank(args){
  	 return this.Command("ZREVRANK");
  } 

proc Zscan(args){
  	 return this.Command("ZSCAN");
  } 

proc Zscore(args){
  	 return this.Command("ZSCORE");
  } 

proc Zunionstore(args){
  	 return this.Command("ZUNIONSTORE");
  } 

proc Append(args){
  	 return this.Command("APPEND");
  } 

proc Bitcount(args){
  	 return this.Command("BITCOUNT");
  } 

proc Bitfield(args){
  	 return this.Command("BITFIELD");
  } 

proc Bitop(args){
  	 return this.Command("BITOP");
  } 

proc Bitpos(args){
  	 return this.Command("BITPOS");
  } 

proc Decr(args){
  	 return this.Command("DECR");
  } 

proc Decrby(args){
  	 return this.Command("DECRBY");
  } 

proc Get(args){
  	 return this.Command("GET");
  } 

proc Getbit(args){
  	 return this.Command("GETBIT");
  } 

proc Getrange(args){
  	 return this.Command("GETRANGE");
  } 

proc Getset(args){
  	 return this.Command("GETSET");
  } 

proc Incr(args){
  	 return this.Command("INCR");
  } 

proc Incrby(args){
  	 return this.Command("INCRBY");
  } 

proc Incrbyfloat(args){
  	 return this.Command("INCRBYFLOAT");
  } 

proc Mget(args){
  	 return this.Command("MGET");
  } 

proc Mset(args){
  	 return this.Command("MSET");
  } 

proc Msetnx(args){
  	 return this.Command("MSETNX");
  } 

proc Psetex(args){
  	 return this.Command("PSETEX");
  } 

proc Set(args){
  	 return this.Command("SET");
  } 

proc Setbit(args){
  	 return this.Command("SETBIT");
  } 

proc Setex(args){
  	 return this.Command("SETEX");
  } 

proc Setnx(args){
  	 return this.Command("SETNX");
  } 

proc Setrange(args){
  	 return this.Command("SETRANGE");
  } 

proc Strlen(args){
  	 return this.Command("STRLEN");
  } 

proc Discard(args){
  	 return this.Command("DISCARD");
  } 

proc Exec(args){
  	 return this.Command("EXEC");
  } 

proc Multi(args){
  	 return this.Command("MULTI");
  } 

proc Unwatch(args){
  	 return this.Command("UNWATCH");
  } 

proc Watch(args){
  	 return this.Command("WATCH");
  } 


}


}