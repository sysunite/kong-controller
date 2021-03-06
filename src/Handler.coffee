conf          = require('config')
Promise       = require('bluebird')
logger        = require('./util/logger')
KongService   = require('./kong/KongService')
ParseInit     = require('./parse/ParseInit')
newService    = require('./NewServiceHandler')
updateService = require('./UpdateServiceHandler')

class Handler

  constructor: (@kongServices = {}) ->

  init: ->
    logger.info("Initializing handler from Kong and Parse...")

    KongService.list()
    .then((services) =>
      @kongServices[s.name] = s for s in services  # Exists in Kong, but not yet applied to handler
    ).then(->
      ParseInit()
    )

  # Handle service registration
  apply: (params) ->
    name           = params.serviceName    # Unique name of the service
    url            = params.serviceUrl     # Url that Kong can reach for this service
    swaggerUrl     = params.swaggerUrl     # Url that this handler can reach for swagger
    swaggerVersion = params.swaggerVersion # Swagger version to check if we need to update

    logger.debug("Received a request from service #{name} and url #{url}.")
    service = @kongServices[name]

    # 1. The service is totally new, neither in Kong nor ever requested here
    if not service?
      service = @kongServices[name] = new KongService(name, url, swaggerUrl, swaggerVersion)
      newService(service)

    # 2. The service exists in Kong, but the first time it applies here
    else if not service.url?
      service.update(url, swaggerUrl, swaggerVersion)
      updateService(service)

    # 3. Service exists in Kong and already applied before, check swagger version if changes are required
    else if service.different(swaggerVersion)
      service.setSwaggerVersion(swaggerVersion)
      updateService(service)

    # 4. No change needed
    else
      logger.debug("No change needed due to same swagger version for service #{name}")
      Promise.resolve()


module.exports = new Handler()
