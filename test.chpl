module Main{
use Redis;
    proc main(){

      var con =  redisConnect("127.0.0.1".localize().c_str(),  6379);
        var reply = redisCommand(con,"PING".localize().c_str()):c_ptr(redisReply);
        var r = reply.deref();

        var s= new string(r.str);

        writeln(s);

    }
}