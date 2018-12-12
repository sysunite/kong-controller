logger   = require('../util/logger')
KongApi  = require('./KongAPI')

class Kong

  getServices: ->
    KongApi.getServices().then((response) ->
      if response.status is 200
        response.data.data
      else
        logger.error(response.data)
        throw new Error("Could not get the services from Kong on URL " + @adminUrl)
    )

  createService: (serviceName, serviceUrl) ->
    KongApi.createService(serviceName, serviceUrl).then((response) ->
      # 201 Created
      logger.info("Kong succesfully created service #{serviceName}")
      response.data
    ).catch((err) ->
      # 409 Conflict
    )

  createRoute: (serviceName, path, method) ->
    KongApi.createRoute(serviceName, path, method).then((response) ->
      # 201 Created
      logger.info("Kong succesfully created route #{path} on service #{serviceName}")
      response.data
    )


module.exports = new Kong()
