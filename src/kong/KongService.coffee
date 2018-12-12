Swagger = require('../util/Swagger')
Kong    = require('./Kong')

class KongService
  constructor:(@name, @url, @swaggerUrl, @cycle) ->
    @routes = []
    @heartbeat = new Date()

  @list: ->
    Kong.getServices().then((services) ->
      (new KongService(s.name) for s in services)
    )

  update: (url, swaggerUrl, cycle) ->
    @url = url
    @swaggerUrl = swaggerUrl
    @cycle = cycle

  different: (cycle) ->
    @cycle isnt cycle

  setCycle: (cycle) ->
    @cycle = cycle

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
