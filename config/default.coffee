module.exports =
  port: 7090

  kong:
    adminUrl: 'http://localhost:8001'

  parse:
    url:        'http://localhost:1337/parse'
    masterKey:  'verysecretmasterkey'
    username:   'admin'
    password:   'secretpassword'

  logging:
    console: 'info'
    file:    'error'
