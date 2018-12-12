Promise      = require('bluebird')
logger       = require('./util/logger')
KongRoute    = require('./kong/KongRoute')
ParseRoute   = require('./parse/ParseRoute')
ParseService = require('./parse/ParseService')

handleNewService = (kongService) ->
  logger.info("Registering #{kongService.name} for the first time.")

  kongService.requestSwagger()
  .then((swagger) =>
    kongService.routes = KongRoute.fromSwagger(kongService, swagger)

    kongService.createAtKong()
  ).then(=>

    Promise.each(kongService.routes, (kongRoute) ->
      kongRoute.createAtKong()
    )
  ).then(=>
    ParseService.createAtParse(kongService)
  ).then((parseService) =>

    Promise.each(kongService.routes, (kongRoute) ->
      ParseRoute.createAtParse(parseService, kongRoute)
    )
  )

module.exports = handleNewService
