class roles::redisset {
class { 'redis':
       daemonize => 'no',
        pid_file => '/var/run/redis.pid',
        timeout => '1800',
        tcp_keepalive => '0',
        log_file => '/logs/redis.log',
        dbfilename => 'cloudmi-cache.rdb',
        workdir => '/data/redis',
      ##repl_disable_tcp_nodelay => true,
        requirepass => '07bb511317c12735ce08b0f2bd4b65d1',
      ##lua_time_limit => '10000',
        slowlog_max_len => '200',
        }
}