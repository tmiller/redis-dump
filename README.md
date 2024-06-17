# Redis::Dump - v0.6

*Redis to JSON and back again. Dump and load Redis databases to/from JSON files.*


## Installation

One of:
1. Gemfile: `gem 'redis-dump', '~> 0.4.0'`
2. Install manually: `gem install redis-dump`
3. Clone with git: `git clone git@github.com:delano/redis-dump.git`



## Usage

There are two executables: `redis-dump` and `redis-load`.

```bash
  $ redis-dump
  $ redis-dump -u 127.0.0.1:6379 > db_full.json
  $ redis-dump -u 127.0.0.1:6379 -d 15 > db_db15.json

  $ < db_full.json redis-load
  $ < db_db15.json redis-load -d 15
  # OR
  $ cat db_full | redis-load
  $ cat db_db15.json | redis-load -d 15

  # You can specify the redis URI via an environment variable
  $ export REDIS_URI=127.0.0.1:6379
  $ redis-dump

  # If your instance uses a password (such as on RedisToGo), you
  # can specify the Redis URL as such:
  # :<password>@<domain>:<port>
  # Note the leading colon is important for specifying no username.
  $ redis-dump -u :234288a830f009980e08@example.redistogo.com:9055
```

### Output format

All redis datatypes are output to a simple JSON object. All objects have the following 5 fields:

* db (Integer)
* key (String)
* ttl (Integer): The amount of time in seconds that the key will live. If no expire is set, it's -1.
* type (String), one of: string, list, set, zset, hash, none.
* value (String): A JSON-encoded string. For keys of type list, set, zset, and hash, the data is given a specific structure (see below).

Here are examples of each datatype:

```json
{"db":0,"key":"hashkey","ttl":-1,"type":"hash","value":{"field_a":"value_a","field_b":"value_b","field_c":"value_c"},"size":42}
{"db":0,"key":"listkey","ttl":-1,"type":"list","value":["value_0","value_1","value_2","value_0","value_1","value_2"],"size":42}
{"db":0,"key":"setkey","ttl":-1,"type":"set","value":["value_2","value_0","value_1","value_3"],"size":28}
{"db":0,"key":"zsetkey","ttl":-1,"type":"zset","value":[["value_0","100"],["value_1","100"],["value_2","200"],["value_3","300"],["value_4","400"]],"size":50}
{"db":0,"key":"stringkey","ttl":79,"type":"string","value":"stringvalue","size":11}
```

## Important notes

### About TTLs

One of the purposes of redis-dump is the ability to restore the database to a known state. When you restore a redis database from a redis-dump file, *the expires are reset to their values at the time the dump was created*. This is different from restoring from Redis' native .rdb or .aof files (expires are stored relative to the actual time they were set).

### Output directly to an encrypted file

For most sensitive data, you should consider encrypting the data directly without writing first to a temp file. You can do this using the power of [gpg](http://www.gnupg.org/) and file descriptors. Here are a couple examples:

```bash
  # Encrypt the data (interactive)
  $ redis-dump -u 127.0.0.1:6379 -d 15 | gpg --force-mdc -v -c > path/2/backup-db1
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/delano/redis-dump.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
