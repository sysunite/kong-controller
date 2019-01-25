conf  = require('config')
axios = require('axios')

class KongAPI
  constructor: ->
    @url = conf.get('kong.adminUrl')

  getServices: ->
    axios.get("#{@url}/services/")

  createService: (name, url) ->
    axios.post("#{@url}/services/", {name, url})

  createRoute: (service, path, method) ->
    axios.post("#{@url}/services/#{service}/routes/", {
      hosts: [service]
      paths: [path]
      methods: [method]
      strip_path: false
    })

module.exports = new KongAPI()
