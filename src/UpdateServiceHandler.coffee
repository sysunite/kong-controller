Promise = require('bluebird')
logger  = require('./util/logger')

updateService = (kongService) ->
  logger.info("Updating service #{kongService.name}..")

  # Update the heartbeat
  kongService.updateHeartbeat()

  # Update the service at Kong and Parse
  # The swagger definition might have changed, reflect that at Kong and Parse
  # currentSwagger = kongService.getSwagger()
  # kongService.requestSwagger()

  # TODO
  return Promise.resolve()

module.exports = updateService
