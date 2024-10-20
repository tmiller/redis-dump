# frozen_string_literal: true

require_relative '../lib/redis/dump'
# require 'pry-byebug'

# The test instance of redis must be running:
# $ redis-server try/redis.conf

@uri_base = "redis://127.0.0.1:6379"

Redis::Dump.debug = true  # leave enabled for CI workflow
Redis::Dump.safe = true
Redis::Dump.with_base64 = true

## Connect to DB
@rdump = Redis::Dump.new 0..1, @uri_base
@rdump.redis_connections.size
#=> 2

## Populate
@rdump.redis(0).set 'stringkey1', 'stringvalue1'
@rdump.redis(0).set 'stringkey2', 'stringvalue2'
@rdump.redis(0).keys.size
#=> 2

## Values are base64 encoded when with_base64=true
@values = @rdump.dump
# Check for values without relying on the order the keys were returned in
encoded_str = "{\"db\":0,\"key\":\"stringkey1\",\"ttl\":-1,\"type\":\"string\",\"value\":\"c3RyaW5ndmFsdWUx\\n\",\"size\":12}"
encoded_str2 = "{\"db\":0,\"key\":\"stringkey2\",\"ttl\":-1,\"type\":\"string\",\"value\":\"c3RyaW5ndmFsdWUy\\n\",\"size\":12}"
[@values.include?(encoded_str), @values.include?(encoded_str2)]
#=> [true, true]

## Can dump
@values = @rdump.dump
@values.size
#=> 2

## Can load data
@rdump.load @values.join
@rdump.redis(0).keys.size
#=> 2

# Clear DB 0
db0 = Redis::Dump.new 0, @uri_base
db0.redis(0).flushdb
db0.redis(0).keys.size
##=> 0

Redis::Dump.safe = true
db0 = Redis::Dump.new 0, @uri_base
db0.redis(0).flushdb
