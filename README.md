# kong-controller

The kong-controller manages services and routes at Kong and Parse.

## Motivation
We tend to promote a microservice architecture of small, reusable and standalone http services that are directly accessed by the client application. Kong fits very well in providing a single endpoint through which these services and routes are exposed to any client SDK. This controller manages the endpoints at Kong and provides authentication through Parse on a per route basis for every service, allowing fine grained ACL control on all endpoints.

###  Kong and OpenResty
Kong is essentially a customizable API Management Layer built on top of Nginx that utilizes OpenResty to dynamically configure NGINX and process HTTP requests.

OpenResty is a software suite that bundles NGINX, a set of modules, LuaJIT, and a set of Lua libraries. Chief among these is `ngx_http_lua_module`, an NGINX module which embeds Lua and provides Lua equivalents for most NGINX request phases. This effectively allows development of NGINX modules in Lua while maintaining high performance (LuaJIT is quite fast), and Kong uses it to provide its core configuration management and plugin management infrastructure.


## How to use

From any microservice that serves a swagger file, do the following request to get registered at Kong and Parse:

GET /apply with the following query parameters:
- serviceName: a unique name of the service
- serviceUrl: a reachable URL for Kong to proxy requests to
- swaggerUrl: the url of the swagger.yml definition
- cycle: any value that when changes, the swagger definition is read again for updates

Example:
```curl
curl --request GET \
  --url 'http://kong_controller_host/apply?serviceName=weaver-database&serviceUrl=http://weaver-database&swaggerUrl=http://weaver-database/swagger.yml&cycle=234'
```
