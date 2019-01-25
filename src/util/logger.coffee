require('colors')
winston = require('winston')      # Logging library
require('winston-daily-rotate-file')
moment  = require('moment')       # Easy date formatting library
config  = require('config')

# Return timestamp correctly formatted
timestamp = ->
  moment().format("YYYY-MM-DD HH:mm:ss")

# Return complete formatted string
formatter = (options) ->
  time    = options.timestamp()
  level   = options.level.toUpperCase()
  message = if options.message? then options.message else ''
  object  = if options.meta? && Object.keys(options.meta).length != 0 then ('\n\t'+ JSON.stringify(options.meta)) else ''
  total   = "#{time} | #{level} | #{message} #{object}"

  # Make message red if error
  total = total.red if level is 'ERROR'
  total

# Create console transports array using timestamp and formatter functions
transports = [new (winston.transports.Console)({
  timestamp
  formatter
  level: "#{config.get('logging.console')}"
})]

# Create file transport
transports.push(new (winston.transports.DailyRotateFile)({
  filename: "./logs/kong-controller.log"
  formatter
  datePattern: '.yyyy-MM-dd.log'
  prepend: false
  level: "#{config.get('logging.file')}"
  }))

# Create logger
logger = new (winston.Logger)({transports})

module.exports = logger
