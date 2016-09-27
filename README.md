# README

This project provides an [ActiveAdmin](http://activeadmin.info/) interface for
CRU staff to enter details for the CRU Conference.

## Populate Development DB

```sh
bundle exec rake dev:populate
```

## Redis

[Redis](http://redis.io/) is required to run this application, even in
development mode.

## Testing

In development mode you can use [Guard](https://github.com/guard/guard) for
continuous testing:

```sh
bundle exec guard
```
