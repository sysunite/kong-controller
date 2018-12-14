# kong-controller

The kong-controller manages services and routes at Kong and Parse.

## Motivation
We tend to promote a microservice architecture of small, reusable and standalone http services that are directly accessed by the client application. Kong fits very well in providing a single endpoint through which these services and routes are exposed to any client SDK. This controller manages the endpoints at Kong and provides authentication through Parse on a per route basis for every service, allowing fine grained ACL control on all endpoints.

###  Kong and OpenResty
Kong is essentially a customizable API Management Layer built on top of Nginx that utilizes OpenResty to dynamically configure NGINX and process HTTP requests.

OpenResty is a software suite that bundles NGINX, a set of modules, LuaJIT, and a set of Lua libraries. Chief among these is `ngx_http_lua_module`, an NGINX module which embeds Lua and provides Lua equivalents for most NGINX request phases. This effectively allows development of NGINX modules in Lua while maintaining high performance (LuaJIT is quite fast), and Kong uses it to provide its core configuration management and plugin management infrastructure.
