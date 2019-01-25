conf  = require('config')
Parse = require('parse/node')

ParseInit = ->
  # Get config vars
  serverURL = conf.get('parse.url')
  masterKey = conf.get('parse.masterKey')
  username  = conf.get('parse.username')
  password  = conf.get('parse.password')

  # Init with app name, null for javascript client key, and provide masterkey
  Parse.initialize("WEAVER", null, masterKey)
  Parse.serverURL = serverURL

  # Send all requests with logged in user
  Parse.User.enableUnsafeCurrentUser()

  # Login Parse
  Parse.User.logIn(username, password)

module.exports = ParseInit
