Swagger = require('../util/Swagger')
Kong    = require('./Kong')

class KongService
  constructor:(@name, @url, @swaggerUrl, @swaggerVersion) ->
    @routes = []
    @heartbeat = new Date()

  @list: ->
    Kong.getServices().then((services) ->
      (new KongService(s.name) for s in services)
    )

  update: (url, swaggerUrl, swaggerVersion) ->
    @url = url
    @swaggerUrl = swaggerUrl
    @swaggerVersion = swaggerVersion

  different: (swaggerVersion) ->
    @swaggerVersion isnt swaggerVersion

  setSwaggerVersion: (swaggerVersion) ->
    @swaggerVersion = swaggerVersion

  updateHeartbeat: ->
    @heartbeat = new Date()

  getSwagger: ->
    @swagger

  createAtKong: ->
    Kong.createService(@name, @url).then((data) =>
      @id = data.id
    )

  requestSwagger: ->
    new Swagger(@swaggerUrl).fetch().then((swagger) =>
      @swagger = swagger
      @swagger
    )

module.exports = KongService
