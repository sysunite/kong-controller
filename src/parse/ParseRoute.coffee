Parse  = require('parse/node')
logger = require('../util/logger')

# This class handles registering and using services on Kong
ParseRoute = Parse.Object.extend("Route"
  # Instance methods
  {}

  # Class methods
  {
    createAtParse: (parseService, kongRoute) ->
      r = new ParseRoute()
      r.set('routeId',    kongRoute.id)
      r.set('path',       kongRoute.path)
      r.set('method',     kongRoute.method)
      r.set('definition', kongRoute.definition)
      r.set('service',    parseService)
      r.save().then((r) ->
        logger.info("Parse succesfully created route #{kongRoute.path}")
        r
      )
  }
)

module.exports = ParseRoute
