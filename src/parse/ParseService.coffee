Parse  = require('parse/node')
logger = require('../util/logger')

# This class handles registering and using services on Kong
ParseService = Parse.Object.extend("Service"
  # Instance methods
  {}

  # Class methods
  {
    createAtParse: (kongService) ->
      s = new ParseService()
      s.set('serviceId',  kongService.id)
      s.set('name',       kongService.name)
      s.set('url',        kongService.url)
      s.set('swaggerUrl', kongService.swaggerUrl)
      s.save().then((s) ->
        logger.info("Parse succesfully created service #{kongService.name}")
        s
      )
  }
)

module.exports = ParseService
