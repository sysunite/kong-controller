# Libs
express  = require('express')
app      = express()
http     = require('http').Server(app)
config   = require('config')
fs       = require('fs')
logger   = require('./util/logger')
Handler  = require('./Handler')
Authenticator = require('./Authenticator')
ensure   = require('./util/parameters').ensure
info     = JSON.parse(fs.readFileSync('./package.json', 'utf8'))

# Initialize the controller, exit if it fails
Handler.init().catch((err) ->
  logger.error(err)
  process.exit(1)
)

# Index page displaying info about this service.
app.get('/', (req, res) ->
  res.status(200).send("#{info.name} #{info.version}")
)

# Swagger page
app.get('/+swagger', (req, res) ->
  res.sendFile('swagger.yml', {root: './static/'})
)

# Services apply by this endpoint to be registerd in Kong and Parse
# The endpoint may be called many times
app.get('/+apply', (req, res) ->
  if ensure(req, res, 'serviceName', 'serviceUrl', 'swaggerUrl', 'cycle')
    Handler.apply(req.query).then(->
      res.status(200).send("Success")
    ).catch((err) ->
      logger.error(err)
      res.status(400).send(err.message)
    )
)

# Called by the Kong plugin to check the ACL of given user in combination with service and route
app.get('/+routeAccess', (req, res) ->
  if ensure(req, res, 'sessionToken', 'routeId')
    Authenticator.verifyRouteAccess(req.query.sessionToken, req.query.routeId).then( ->
      res.status(200).send("Authenticated")
    ).catch((err) ->
      res.status(403).send("Permission denied")
    )
)

app.get('/+projectAccess', (req, res) ->
  if ensure(req, res, 'sessionToken', 'projectId')
    Authenticator.verifyProjectAccess(req.query.sessionToken, req.query.projectId).then( ->
      res.status(200).send("Authenticated")
    ).catch((err) ->
      res.status(403).send("Permission denied")
    )
)

app.get('/+getAllowedGraphAccess', (req, res) ->
  if ensure(req, res, 'sessionToken', 'projectId')
    Authenticator.getAllowedGraphAccess(req.query.sessionToken, req.query.projectId).then((result) ->
      res.status(200).send(result)
    ).catch((err) ->
      logger.error(err)
      res.status(400).send(err)
    )
)

# Run
port = process.env.PORT or config.get('port')
http.listen(port, ->
  logger.info "#{info.name} #{info.version} running on port #{port}"
  return
)
