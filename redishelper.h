#include<hiredis/hiredis.h>


int getRedisReplyTypeFromPointer(redisReply* reply){
    return reply->type;
}

int getRedisReplyType(redisReply reply){
    return reply.type;
}

//redisReply getRedisReply(redisReply** reply,int i){
  //  return *reply[i];
//}

redisReply* getRedisReply(redisContext* con,redisReply* reply){
     redisGetReply(con,(void**)&reply);
     return reply;
}

