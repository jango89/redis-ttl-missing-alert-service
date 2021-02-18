## Redis ttl monitoring

Service monitors Redis keys created without any Time To Live (TTL) and alerts based on different configurations 
provided by different teams. 

**NOT FOR PRODUCTION ENVIRONMENTS**. Preferred only on Testing/Staging environments.

### Motivation

To stop or try to alert devs before persisting keys to redis with no TTL.

Most of the time, the reason will be keys with no Time to live(TTL). That means, the data exists forever until we delete it explicitly.

## How to use

1. Duplicate env.sample file and fill with values.
2. Move this file to `services` folder.
3. Run `sh run_from_bash.sh`

## How it works

1. Crontab runs once a day. Can be configured in the file called `crontab`.
2. Each file in `services` folder is picked.
3. Evaluate ttl missing keys based on configuration.
4. Notify teams about the TTL missing keys.

## Run Using Docker
1. ```docker build --build-arg env_host=hostname --build-arg env_port=30363  -t redis-ttl-missing-alert-service.```
2. ```docker run redis-ttl-missing-alert-service:latest```

## Start Container Using Docker
1.```docker build --build-arg env_host=hostname --build-arg env_port=30363  -t redis-ttl-missing-alert-service.``` 

2.```docker container create redis-ttl-missing-alert-service:latest```

3.```docker start #container_name```

## Sample Alert 

![Image](https://github.com/jango89/redis-ttl-missing-alert-service/blob/master/Screenshot%202021-02-18%20at%2017.50.44.png)
