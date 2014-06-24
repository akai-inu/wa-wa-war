c = require __dirname + '/lib/constants'
Logger = require __dirname + '/lib/Logger'

Logger.info '========================================'
Logger.info 'Starting wa-wa-war server ver.' + c.VERSION
Logger.info '========================================'
Logger.info 'HTTP_ADDR = ' + c.HTTP_ADDR
Logger.info 'SOCKET_ADDR = ' + c.SOCKET_ADDR

require('./lib/HttpServer').singleton().start()
require('./lib/SocketServer').singleton().start()

Logger.info 'Server successfully started.'
