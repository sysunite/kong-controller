Promise = require('bluebird')
logger  = require('./util/logger')
Parse   = require('parse/node')

class Authenticator

  verifyRouteAccess: (sessionToken, routeId) ->
    new Parse.Query('Route')
    .equalTo('routeId', routeId)
    .first({sessionToken})
    .then((result) ->
      return Promise.reject() if not result?
    )

  verifyProjectAccess: (sessionToken, projectId) ->
    new Parse.Query('Project')
    .equalTo('projectId', projectId)
    .first({sessionToken})
    .then((result) ->
      return Promise.reject() if not result?
    )

  getAllowedGraphAccess: (sessionToken, projectId) ->
    new Parse.Query('Graph')
    .select('name')
    .matchesQuery('project',
      new Parse.Query('Project')
      .equalTo('projectId', projectId)
    )
    .find({sessionToken})
    .then((graphs) ->
      (graph.get('name') for graph in graphs or [])
    )

module.exports = new Authenticator()
