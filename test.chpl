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