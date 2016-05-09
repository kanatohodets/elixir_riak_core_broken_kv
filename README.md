# Store-fetch

## Warning: this repo is a deliberately bad example. Don't use this as the basis for anything serious.

A simple Riak Core application in Elixir, which allows you to 'store' and
'fetch' data to/from ETS around the ring.

This is only useful as an intentionally broken example, because it has no write/read
replication or handoff handling. Thus, any node failure in the ring will result in
permanently lost data.
