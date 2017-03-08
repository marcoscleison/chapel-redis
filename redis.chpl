/*
 * Copyright (C) 2016 Marcos Cleison Silva Santana
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE_2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
module Redis{

    use SysBasic;

    require "hiredis/hiredis.h","-lhiredis";
		require "redishelper.h";
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
	var integer: c_longlong;
	var len: c_int;
	var str: c_string;
	var elements: c_int;
	var element: c_ptr(c_ptr(redisReply));
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
extern proc  redisGetReply(c: c_ptr(redisContext ), reply: c_ptr(c_void_ptr)):c_int;
extern proc  redisGetReplyFromReader(c: c_ptr(redisContext ), reply: c_ptr(void ) ):c_int;
extern proc  redisAppendFormattedCommand(c: c_ptr(redisContext ), cmd: c_string, len: c_int ):c_int;
extern proc  redisvAppendCommand(c: c_ptr(redisContext ), format: c_string, ap...?k ):c_int;
extern proc  redisAppendCommand(c: c_ptr(redisContext ), format: c_string ):c_int;
extern proc  redisAppendCommandArgv(c: c_ptr(redisContext ), argc: c_int, argv: c_string, argvlen: c_ptr(c_int ) ):c_int;
extern proc  redisvCommand(c: c_ptr(redisContext ), format: c_string, ap...?k ):c_void_ptr;
extern proc  redisCommand(c: c_ptr(redisContext ), format: c_string ):c_void_ptr;
extern proc  redisCommandArgv(c: c_ptr(redisContext ), argc: c_int, argv: c_string, argvlen: c_ptr(c_int ) ):c_void_ptr;

extern const REDIS_ERR:int; 
extern const REDIS_OK:int;
extern const REDIS_ERR_IO:int;  
extern const REDIS_ERR_EOF:int; 
extern const REDIS_ERR_PROTOCOL:int;  
extern const REDIS_ERR_OOM:int;  
extern const REDIS_ERR_OTHER:int;  
extern const REDIS_REPLY_STRING:int; 
extern const REDIS_REPLY_ARRAY:int; 
extern const REDIS_REPLY_INTEGER:int; 
extern const REDIS_REPLY_NIL:int; 
extern const REDIS_REPLY_STATUS:int; 
extern const REDIS_REPLY_ERROR:int; 
extern const REDIS_READER_MAX_BUF:int; 

extern proc getRedisReplyTypeFromPointer(reply:c_ptr(redisReply)):c_int;
extern proc getRedisReplyType(reply:redisReply):c_int;
extern proc getRedisReply(con:c_ptr(redisContext), reply:c_ptr(redisReply)): c_ptr(redisReply);
 proc getProcessArguments(args...?n){
  var str="";
  for param i in 1..n {
    str += " "+args(i);
  }
	return str;
 }

class RedisResult{
	var reply:c_ptr(redisReply) ;
	var _type:int;

	proc RedisResult(reply:c_ptr(redisReply) ){
		this.reply=reply:c_ptr(redisReply);
		this._type = getRedisReplyTypeFromPointer(reply):int;
	}
	
	proc asString():string{
		var rep:redisReply = this.reply.deref():redisReply;
			if(this._type==REDIS_REPLY_STRING){
				return new string(rep.str);
			}else{
				return "";
			}
	}

proc getChannelOperation(){
		if(this._type==REDIS_REPLY_ARRAY){
				
			var rep:redisReply = this.reply.deref():redisReply;
			writeln("elements ",rep.elements);
			if(rep.elements==3){
					var rel = rep.element[0].deref():redisReply;
				 	return new string(rel.str);
				
			}else{
				return "";
			}
		}
		else{			
			return "";
		}
}

proc getChannelName(){
	if(this._type==REDIS_REPLY_ARRAY){
				
			var rep:redisReply = this.reply.deref():redisReply;
			
			if(rep.elements==3){
					var rel = rep.element[1].deref():redisReply;
				 	return new string(rel.str);
				
			}else{
				return "";
			}
		}
		else{			
			return "";
		}
}
proc getChannelMessage(){
	if(this._type==REDIS_REPLY_ARRAY){
				
			var rep:redisReply = this.reply.deref():redisReply;
			
			if(rep.elements==3){
					var rel = rep.element[2].deref():redisReply;
				 	return new string(rel.str);
				
			}else{
				return "";
			}
		}
		else{			
			return "";
		}
}
	proc isChannelSubscribe():bool{
		
		return this.getChannelOperation()=="subscribe";
	}

proc isChannelMessage():bool{
		
		return this.getChannelOperation()=="message";
	}


  proc asInt():int{
		var rep:redisReply = this.reply.deref():redisReply;
		if(this._type==REDIS_REPLY_INTEGER){
			return rep.integer:int;
		}else{
			return 0;
		}
	}

proc asStatus(){
	 var rep:redisReply = this.reply.deref():redisReply;
		if(this._type==REDIS_REPLY_STATUS){
					return new string(rep.str:c_string);
				}
				return "";
}	
	proc isNil():bool{
				if(this._type==REDIS_REPLY_NIL){
					return true;
				}
				return false;
	}

	proc Length():int{
		 var rep:redisReply = this.reply.deref():redisReply;
		 return rep.elements:int;
	}

	iter asResults(){
		if(this._type==REDIS_REPLY_ARRAY){
			var rep:redisReply = this.reply.deref():redisReply;			
			var i:int=0;
			while(i<rep.elements){
				var rel = rep.element[i];
				 yield new RedisResult(rel);	
				i+=1;
			}
		}
		else{			
			yield this;
		}

	}

	proc ~RedisResult(){
		freeReplyObject(this.reply);
	}

}


class Redis{
	var con:c_ptr(redisContext );
var lock$: sync bool;
	proc Redis(host:string="127.0.0.1",port:int=6379){
		      this.con =  redisConnect(host.localize().c_str(),  port:c_int);
					this.lock$.writeXF( true ); 

	}

	proc Command(format: string, args...?n){
   this.lock$;
		var commands:string = format+" "+getProcessArguments((...args));
		var result = redisCommand(this.con,commands.localize().c_str()):c_ptr(redisReply);
		this.lock$.writeXF( true ); 
		return new RedisResult(result);
	}

proc Pfadd(args...?n){
  	 return this.Command("PFADD",(...args));
  } 

proc Pfcount(args...?n){
  	 return this.Command("PFCOUNT",(...args));
  } 

proc Pfmerge(args...?n){
  	 return this.Command("PFMERGE",(...args));
  } 

proc Hdel(args...?n){
  	 return this.Command("HDEL",(...args));
  } 

proc Hexists(args...?n){
  	 return this.Command("HEXISTS",(...args));
  } 

proc Hget(args...?n){
  	 return this.Command("HGET",(...args));
  } 

proc Hgetall(args...?n){
  	 return this.Command("HGETALL",(...args));
  } 

proc Hincrby(args...?n){
  	 return this.Command("HINCRBY",(...args));
  } 

proc Hincrbyfloat(args...?n){
  	 return this.Command("HINCRBYFLOAT",(...args));
  } 

proc Hkeys(args...?n){
  	 return this.Command("HKEYS",(...args));
  } 

proc Hlen(args...?n){
  	 return this.Command("HLEN",(...args));
  } 

proc Hmget(args...?n){
  	 return this.Command("HMGET",(...args));
  } 

proc Hmset(args...?n){
  	 return this.Command("HMSET",(...args));
  } 

proc Hscan(args...?n){
  	 return this.Command("HSCAN",(...args));
  } 

proc Hset(args...?n){
  	 return this.Command("HSET",(...args));
  } 

proc Hsetnx(args...?n){
  	 return this.Command("HSETNX",(...args));
  } 

proc Hstrlen(args...?n){
  	 return this.Command("HSTRLEN",(...args));
  } 

proc Hvals(args...?n){
  	 return this.Command("HVALS",(...args));
  } 

proc Geoadd(args...?n){
  	 return this.Command("GEOADD",(...args));
  } 

proc Geodist(args...?n){
  	 return this.Command("GEODIST",(...args));
  } 

proc Geohash(args...?n){
  	 return this.Command("GEOHASH",(...args));
  } 

proc Geopos(args...?n){
  	 return this.Command("GEOPOS",(...args));
  } 

proc Georadius(args...?n){
  	 return this.Command("GEORADIUS",(...args));
  } 

proc Georadiusbymember(args...?n){
  	 return this.Command("GEORADIUSBYMEMBER",(...args));
  } 

proc Auth(args...?n){
  	 return this.Command("AUTH",(...args));
  } 

proc Echo(args...?n){
  	 return this.Command("ECHO",(...args));
  } 

proc Ping(args...?n){
  	 return this.Command("PING",(...args));
  } 

proc Quit(args...?n){
  	 return this.Command("QUIT",(...args));
  } 

proc Select(args...?n){
  	 return this.Command("SELECT",(...args));
  } 

proc Swapdb(args...?n){
  	 return this.Command("SWAPDB",(...args));
  } 

proc ClusterAddslots(args...?n){
  	 return this.Command("CLUSTER ADDSLOTS",(...args));
  } 

proc ClusterCount_Failure_Reports(args...?n){
  	 return this.Command("CLUSTER COUNT-FAILURE-REPORTS",(...args));
  } 

proc ClusterCountkeysinslot(args...?n){
  	 return this.Command("CLUSTER COUNTKEYSINSLOT",(...args));
  } 

proc ClusterDelslots(args...?n){
  	 return this.Command("CLUSTER DELSLOTS",(...args));
  } 

proc ClusterFailover(args...?n){
  	 return this.Command("CLUSTER FAILOVER",(...args));
  } 

proc ClusterForget(args...?n){
  	 return this.Command("CLUSTER FORGET",(...args));
  } 

proc ClusterGetkeysinslot(args...?n){
  	 return this.Command("CLUSTER GETKEYSINSLOT",(...args));
  } 

proc ClusterInfo(args...?n){
  	 return this.Command("CLUSTER INFO",(...args));
  } 

proc ClusterKeyslot(args...?n){
  	 return this.Command("CLUSTER KEYSLOT",(...args));
  } 

proc ClusterMeet(args...?n){
  	 return this.Command("CLUSTER MEET",(...args));
  } 

proc ClusterNodes(args...?n){
  	 return this.Command("CLUSTER NODES",(...args));
  } 

proc ClusterReplicate(args...?n){
  	 return this.Command("CLUSTER REPLICATE",(...args));
  } 

proc ClusterReset(args...?n){
  	 return this.Command("CLUSTER RESET",(...args));
  } 

proc ClusterSaveconfig(args...?n){
  	 return this.Command("CLUSTER SAVECONFIG",(...args));
  } 

proc ClusterSet_Config_Epoch(args...?n){
  	 return this.Command("CLUSTER SET_CONFIG_EPOCH",(...args));
  } 

proc ClusterSetslot(args...?n){
  	 return this.Command("CLUSTER SETSLOT",(...args));
  } 

proc ClusterSlaves(args...?n){
  	 return this.Command("CLUSTER SLAVES",(...args));
  } 

proc ClusterSlots(args...?n){
  	 return this.Command("CLUSTER SLOTS",(...args));
  } 

proc Readonly(args...?n){
  	 return this.Command("READONLY",(...args));
  } 

proc Readwrite(args...?n){
  	 return this.Command("READWRITE",(...args));
  } 

proc Del(args...?n){
  	 return this.Command("DEL",(...args));
  } 

proc Dump(args...?n){
  	 return this.Command("DUMP",(...args));
  } 

proc Exists(args...?n){
  	 return this.Command("EXISTS",(...args));
  } 

proc Expire(args...?n){
  	 return this.Command("EXPIRE",(...args));
  } 

proc Expireat(args...?n){
  	 return this.Command("EXPIREAT",(...args));
  } 

proc Keys(args...?n){
  	 return this.Command("KEYS",(...args));
  } 

proc Migrate(args...?n){
  	 return this.Command("MIGRATE",(...args));
  } 

proc Move(args...?n){
  	 return this.Command("MOVE",(...args));
  } 

proc Object(args...?n){
  	 return this.Command("OBJECT",(...args));
  } 

proc Persist(args...?n){
  	 return this.Command("PERSIST",(...args));
  } 

proc Pexpire(args...?n){
  	 return this.Command("PEXPIRE",(...args));
  } 

proc Pexpireat(args...?n){
  	 return this.Command("PEXPIREAT",(...args));
  } 

proc Pttl(args...?n){
  	 return this.Command("PTTL",(...args));
  } 

proc Randomkey(args...?n){
  	 return this.Command("RANDOMKEY",(...args));
  } 

proc Rename(args...?n){
  	 return this.Command("RENAME",(...args));
  } 

proc Renamenx(args...?n){
  	 return this.Command("RENAMENX",(...args));
  } 

proc Restore(args...?n){
  	 return this.Command("RESTORE",(...args));
  } 

proc Scan(args...?n){
  	 return this.Command("SCAN",(...args));
  } 

proc Sort(args...?n){
  	 return this.Command("SORT",(...args));
  } 

proc Touch(args...?n){
  	 return this.Command("TOUCH",(...args));
  } 

proc Ttl(args...?n){
  	 return this.Command("TTL",(...args));
  } 

proc Type(args...?n){
  	 return this.Command("TYPE",(...args));
  } 

proc Unlink(args...?n){
  	 return this.Command("UNLINK",(...args));
  } 

proc Wait(args...?n){
  	 return this.Command("WAIT",(...args));
  } 

proc Blpop(args...?n){
  	 return this.Command("BLPOP",(...args));
  } 

proc Brpop(args...?n){
  	 return this.Command("BRPOP",(...args));
  } 

proc Brpoplpush(args...?n){
  	 return this.Command("BRPOPLPUSH",(...args));
  } 

proc Lindex(args...?n){
  	 return this.Command("LINDEX",(...args));
  } 

proc Linsert(args...?n){
  	 return this.Command("LINSERT",(...args));
  } 

proc Llen(args...?n){
  	 return this.Command("LLEN",(...args));
  } 

proc Lpop(args...?n){
  	 return this.Command("LPOP",(...args));
  } 

proc Lpush(args...?n){
  	 return this.Command("LPUSH",(...args));
  } 

proc Lpushx(args...?n){
  	 return this.Command("LPUSHX",(...args));
  } 

proc Lrange(args...?n){
  	 return this.Command("LRANGE",(...args));
  } 

proc Lrem(args...?n){
  	 return this.Command("LREM",(...args));
  } 

proc Lset(args...?n){
  	 return this.Command("LSET",(...args));
  } 

proc Ltrim(args...?n){
  	 return this.Command("LTRIM",(...args));
  } 

proc Rpop(args...?n){
  	 return this.Command("RPOP",(...args));
  } 

proc Rpoplpush(args...?n){
  	 return this.Command("RPOPLPUSH",(...args));
  } 

proc Rpush(args...?n){
  	 return this.Command("RPUSH",(...args));
  } 

proc Rpushx(args...?n){
  	 return this.Command("RPUSHX",(...args));
  } 

proc Psubscribe(args...?n,cb:func(RedisResult,void)){
  	 var result=this.Command("PSUBSCRIBE",(...args));
		 delete result;

var reply:c_ptr(redisReply); 
		
		 reply = getRedisReply(this.con,reply);

		 var status = getRedisReplyTypeFromPointer(reply):int;
		 //Change this
		 while(1) {
				var res = new RedisResult(reply);
			
			
				
				cb(res);

				reply = getRedisReply(this.con,reply);
				status = getRedisReplyTypeFromPointer(reply):int;
				
				delete res;
		}

  } 

proc Publish(args...?n){
  	 return this.Command("PUBLISH",(...args));
  } 

proc Pubsub(args...?n){
  	 return this.Command("PUBSUB",(...args));
  } 

proc Punsubscribe(args...?n){
  	 return this.Command("PUNSUBSCRIBE",(...args));
  } 

proc Subscribe(args...?n,cb:func(RedisResult,void)){
  	 var result = this.Command("SUBSCRIBE",(...args));
		 delete result;

     var reply:c_ptr(redisReply); 

		 reply = getRedisReply(this.con,reply);
		 var status = getRedisReplyTypeFromPointer(reply):int;
		 //Change this
		 while(1) {
				var res = new RedisResult(reply);	
				cb(res);
				reply = getRedisReply(this.con,reply);
				status = getRedisReplyTypeFromPointer(reply):int;
				delete res;
		}

  } 

proc Unsubscribe(args...?n){
  	 return this.Command("UNSUBSCRIBE",(...args));
  } 

proc Eval(args...?n){
  	 return this.Command("EVAL",(...args));
  } 

proc Evalsha(args...?n){
  	 return this.Command("EVALSHA",(...args));
  } 

proc ScriptDebug(args...?n){
  	 return this.Command("SCRIPT DEBUG",(...args));
  } 

proc ScriptExists(args...?n){
  	 return this.Command("SCRIPT EXISTS",(...args));
  } 

proc ScriptFlush(args...?n){
  	 return this.Command("SCRIPT FLUSH",(...args));
  } 

proc ScriptKill(args...?n){
  	 return this.Command("SCRIPT KILL",(...args));
  } 

proc ScriptLoad(args...?n){
  	 return this.Command("SCRIPT LOAD",(...args));
  } 

proc Bgrewriteaof(args...?n){
  	 return this.Command("BGREWRITEAOF",(...args));
  } 

proc Bgsave(args...?n){
  	 return this.Command("BGSAVE",(...args));
  } 

proc ClientGetname(args...?n){
  	 return this.Command("CLIENT GETNAME",(...args));
  } 

proc ClientKill(args...?n){
  	 return this.Command("CLIENT KILL",(...args));
  } 

proc ClientList(args...?n){
  	 return this.Command("CLIENT LIST",(...args));
  } 

proc ClientPause(args...?n){
  	 return this.Command("CLIENT PAUSE",(...args));
  } 

proc ClientReply(args...?n){
  	 return this.Command("CLIENT REPLY",(...args));
  } 

proc ClientSetname(args...?n){
  	 return this.Command("CLIENT SETNAME",(...args));
  } 

proc Command(args...?n){
  	 return this.Command("COMMAND",(...args));
  } 

proc CommandCount(args...?n){
  	 return this.Command("COMMAND COUNT",(...args));
  } 

proc CommandGetkeys(args...?n){
  	 return this.Command("COMMAND GETKEYS",(...args));
  } 

proc CommandInfo(args...?n){
  	 return this.Command("COMMAND INFO",(...args));
  } 

proc ConfigGet(args...?n){
  	 return this.Command("CONFIG GET",(...args));
  } 

proc ConfigResetstat(args...?n){
  	 return this.Command("CONFIG RESETSTAT",(...args));
  } 

proc ConfigRewrite(args...?n){
  	 return this.Command("CONFIG REWRITE",(...args));
  } 

proc ConfigSet(args...?n){
  	 return this.Command("CONFIG SET",(...args));
  } 

proc Dbsize(args...?n){
  	 return this.Command("DBSIZE",(...args));
  } 

proc DebugObject(args...?n){
  	 return this.Command("DEBUG OBJECT",(...args));
  } 

proc DebugSegfault(args...?n){
  	 return this.Command("DEBUG SEGFAULT",(...args));
  } 

proc Flushall(args...?n){
  	 return this.Command("FLUSHALL",(...args));
  } 

proc Flushdb(args...?n){
  	 return this.Command("FLUSHDB",(...args));
  } 

proc Info(args...?n){
  	 return this.Command("INFO",(...args));
  } 

proc Lastsave(args...?n){
  	 return this.Command("LASTSAVE",(...args));
  } 

proc Monitor(args...?n){
  	 return this.Command("MONITOR",(...args));
  } 

proc Role(args...?n){
  	 return this.Command("ROLE",(...args));
  } 

proc Save(args...?n){
  	 return this.Command("SAVE",(...args));
  } 

proc Shutdown(args...?n){
  	 return this.Command("SHUTDOWN",(...args));
  } 

proc Slaveof(args...?n){
  	 return this.Command("SLAVEOF",(...args));
  } 

proc Slowlog(args...?n){
  	 return this.Command("SLOWLOG",(...args));
  } 

proc Sync(args...?n){
  	 return this.Command("SYNC",(...args));
  } 

proc Time(args...?n){
  	 return this.Command("TIME",(...args));
  } 

proc Sadd(args...?n){
  	 return this.Command("SADD",(...args));
  } 

proc Scard(args...?n){
  	 return this.Command("SCARD",(...args));
  } 

proc Sdiff(args...?n){
  	 return this.Command("SDIFF",(...args));
  } 

proc Sdiffstore(args...?n){
  	 return this.Command("SDIFFSTORE",(...args));
  } 

proc Sinter(args...?n){
  	 return this.Command("SINTER",(...args));
  } 

proc Sinterstore(args...?n){
  	 return this.Command("SINTERSTORE",(...args));
  } 

proc Sismember(args...?n){
  	 return this.Command("SISMEMBER",(...args));
  } 

proc Smembers(args...?n){
  	 return this.Command("SMEMBERS",(...args));
  } 

proc Smove(args...?n){
  	 return this.Command("SMOVE",(...args));
  } 

proc Spop(args...?n){
  	 return this.Command("SPOP",(...args));
  } 

proc Srandmember(args...?n){
  	 return this.Command("SRANDMEMBER",(...args));
  } 

proc Srem(args...?n){
  	 return this.Command("SREM",(...args));
  } 

proc Sscan(args...?n){
  	 return this.Command("SSCAN",(...args));
  } 

proc Sunion(args...?n){
  	 return this.Command("SUNION",(...args));
  } 

proc Sunionstore(args...?n){
  	 return this.Command("SUNIONSTORE",(...args));
  } 

proc Zadd(args...?n){
  	 return this.Command("ZADD",(...args));
  } 

proc Zcard(args...?n){
  	 return this.Command("ZCARD",(...args));
  } 

proc Zcount(args...?n){
  	 return this.Command("ZCOUNT",(...args));
  } 

proc Zincrby(args...?n){
  	 return this.Command("ZINCRBY",(...args));
  } 

proc Zinterstore(args...?n){
  	 return this.Command("ZINTERSTORE",(...args));
  } 

proc Zlexcount(args...?n){
  	 return this.Command("ZLEXCOUNT",(...args));
  } 

proc Zrange(args...?n){
  	 return this.Command("ZRANGE",(...args));
  } 

proc Zrangebylex(args...?n){
  	 return this.Command("ZRANGEBYLEX",(...args));
  } 

proc Zrangebyscore(args...?n){
  	 return this.Command("ZRANGEBYSCORE",(...args));
  } 

proc Zrank(args...?n){
  	 return this.Command("ZRANK",(...args));
  } 

proc Zrem(args...?n){
  	 return this.Command("ZREM",(...args));
  } 

proc Zremrangebylex(args...?n){
  	 return this.Command("ZREMRANGEBYLEX",(...args));
  } 

proc Zremrangebyrank(args...?n){
  	 return this.Command("ZREMRANGEBYRANK",(...args));
  } 

proc Zremrangebyscore(args...?n){
  	 return this.Command("ZREMRANGEBYSCORE",(...args));
  } 

proc Zrevrange(args...?n){
  	 return this.Command("ZREVRANGE",(...args));
  } 

proc Zrevrangebylex(args...?n){
  	 return this.Command("ZREVRANGEBYLEX",(...args));
  } 

proc Zrevrangebyscore(args...?n){
  	 return this.Command("ZREVRANGEBYSCORE",(...args));
  } 

proc Zrevrank(args...?n){
  	 return this.Command("ZREVRANK",(...args));
  } 

proc Zscan(args...?n){
  	 return this.Command("ZSCAN",(...args));
  } 

proc Zscore(args...?n){
  	 return this.Command("ZSCORE",(...args));
  } 

proc Zunionstore(args...?n){
  	 return this.Command("ZUNIONSTORE",(...args));
  } 

proc Append(args...?n){
  	 return this.Command("APPEND",(...args));
  } 

proc Bitcount(args...?n){
  	 return this.Command("BITCOUNT",(...args));
  } 

proc Bitfield(args...?n){
  	 return this.Command("BITFIELD",(...args));
  } 

proc Bitop(args...?n){
  	 return this.Command("BITOP",(...args));
  } 

proc Bitpos(args...?n){
  	 return this.Command("BITPOS",(...args));
  } 

proc Decr(args...?n){
  	 return this.Command("DECR",(...args));
  } 

proc Decrby(args...?n){
  	 return this.Command("DECRBY",(...args));
  } 

proc Get(args...?n){
  	 return this.Command("GET",(...args));
  } 

proc Getbit(args...?n){
  	 return this.Command("GETBIT",(...args));
  } 

proc Getrange(args...?n){
  	 return this.Command("GETRANGE",(...args));
  } 

proc Getset(args...?n){
  	 return this.Command("GETSET",(...args));
  } 

proc Incr(args...?n){
  	 return this.Command("INCR",(...args));
  } 

proc Incrby(args...?n){
  	 return this.Command("INCRBY",(...args));
  } 

proc Incrbyfloat(args...?n){
  	 return this.Command("INCRBYFLOAT",(...args));
  } 

proc Mget(args...?n){
  	 return this.Command("MGET",(...args));
  } 

proc Mset(args...?n){
  	 return this.Command("MSET",(...args));
  } 

proc Msetnx(args...?n){
  	 return this.Command("MSETNX",(...args));
  } 

proc Psetex(args...?n){
  	 return this.Command("PSETEX",(...args));
  } 

proc Set(args...?n){
  	 return this.Command("SET",(...args));
  } 

proc Setbit(args...?n){
  	 return this.Command("SETBIT",(...args));
  } 

proc Setex(args...?n){
  	 return this.Command("SETEX",(...args));
  } 

proc Setnx(args...?n){
  	 return this.Command("SETNX",(...args));
  } 

proc Setrange(args...?n){
  	 return this.Command("SETRANGE",(...args));
  } 

proc Strlen(args...?n){
  	 return this.Command("STRLEN",(...args));
  } 

proc Discard(args...?n){
  	 return this.Command("DISCARD",(...args));
  } 

proc Exec(args...?n){
  	 return this.Command("EXEC",(...args));
  } 

proc Multi(args...?n){
  	 return this.Command("MULTI",(...args));
  } 

proc Unwatch(args...?n){
  	 return this.Command("UNWATCH",(...args));
  } 

proc Watch(args...?n){
  	 return this.Command("WATCH",(...args));
  } 

}


}