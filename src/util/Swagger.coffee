SwaggerParser = require('swagger-parser')
logger        = require('./logger')

class Swagger
  constructor:(@url) ->

  fetch: ->
    logger.info("Requesting swagger definition at #{@url}")

    SwaggerParser.validate(@url).then((api) =>
      @description = api.info.description
      @version     = api.info.version
      @author      = api.info.contact.email
      @paths       = (@_parsePath(path, details) for path, details of api.paths)

      logger.info("Service #{@description} loaded with #{@paths.length} Swagger paths parsed")
      @
    )

  _parsePath: (path, details) ->
    if details.get?
      {path, method: "GET",  definition: details.get}
    else if details.post?
      {path, method: "POST", definition: details.post}
    else
      throw new Error("Unable to add #{path} operation to #{@description} service, only get and post operations are supported")

module.exports = Swagger
