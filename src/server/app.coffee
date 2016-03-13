c = require __dirname + '/lib/Constants'
Logger = require __dirname + '/lib/Logger'

Logger.info '========================================'
Logger.info '===     Starting wa-wa-war server    ==='
Logger.info '========================================'
Logger.info 'VERSION = %s', c.VERSION
Logger.info 'ENVIRONMENT = %s', c.ENVIRONMENT
Logger.info 'HTTP_ADDR = %s', c.HTTP_ADDR
Logger.info 'SOCKET_ADDR = %s', c.SOCKET_ADDR

require('./lib/HttpServer').singleton().start()
require('./lib/SocketServer').singleton().start()

Logger.info 'Server successfully started.'
