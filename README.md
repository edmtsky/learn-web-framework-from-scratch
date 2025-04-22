This is a study project in order to learn how to implement your own, Phoenix-like
MVC web framework from scratch.


## A brief description of the contents

- cowboy_example - simplest web-server
- 02_experimental-server - experimental http server from scratch
- webfw
  - webfw_http_server      - simple http server for my own web-framework
                             (learning alternative to the cowboy)
  - test_webfw_http_server - sample app to test the webfw_http_server library
  - plug_webfw_http_server - learning alternative to the plug_cowboy
  - webfw                  - my own implementation of mvc web framework

- 03-plug - separate scripts for initial acquaintance with the `Plug` library
- html_eex_web_app - playground to checkout EEx to evaluate html with templates

- tasks_web - simple CRUD-web-app to manage list of tasks - a complete web
  application built on the current version of the implementation of own mvc
  web-framework (webfw)


To reproduce the writting of the web framework from scratch, you need to go
through the history of the git-repository in stages switching(checkout) on the
history of commits from the very beginning.



### TODOList

- [-] Structure the contents in a more understandable form,
      (put the initial framework code into a separate directory)
- [-] remove or fix depreated parts used for writing and testing webfw to work
      this latest version of webfw
