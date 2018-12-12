Kong = require('./Kong')

class KongRoute
  constructor:(@kongService, @path, @method) ->

  @fromSwagger: (kongService, swagger) ->
    (new KongRoute(kongService, p.path, p.method) for p in swagger.paths)

  createAtKong: ->
    Kong.createRoute(@kongService.name, @path, @method).then((data) =>
      @id = data.id
    )

module.exports = KongRoute
