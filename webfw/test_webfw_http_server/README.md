# TestWebfwHttpServer

This is a sample long-running web-application what use the webfw_http_server
as an external dependency.
This application is created to test the `webfw_http_server` library.

## Note:
to play with this subproject you should checkout repo to the commit: `df3f6c2`
(to get the first version with responder, not with dispatcher for Plug lib)


it was created by:
```sh
mix new test_webfw_http_server --sup
```

```sh
mix deps.get
```



check out:
```sh
mix run --no-halt

Compiling 1 file (.ex)
Generated test_webfw_http_server app

18:35:03.976 [info] Started a webserver on port 4001

#(1)
18:35:06.540 [info] Received HTTP request GET at /hello

18:35:06.549 [info] Response sent:
HTTP/1.1 200
content-length: 12
content-type: text/html

Hello World


#(2)
18:35:15.839 [info] Received HTTP request GET at /bad

18:35:15.839 [info] Response sent:
HTTP/1.1 404
content-length: 10
content-type: text/html

Not Found
```


- (1):
```sh
curl http://localhost:4001/hello
Hello World
```

- (2):
```sh
curl http://localhost:4001/bad
Not Found
```


## to check out the concurrency

t1:
```sh
mix run --no-halt
```

t2:
```sh
curl http://localhost:4001/long-operation
# hands 3 seconds
Lone-operation done
```

t3:
```sh
curl http://localhost:4001/hello
Hello World
```

