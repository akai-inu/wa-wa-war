util = require 'util'
http = require 'http'
fs = require 'fs'
constants = require './lib/constants'
wwwar = require './lib/wwwar/Core'
Connector = require './lib/Connector'

APP_PATH = __dirname + '/..'
PUBLIC_PATH = APP_PATH + '/public'

serverMain = (req, res) ->
	getContentType = (fileName) ->
		fileType = [
			[ /\.js$/, 'text/javascript' ]
			[ /\.html$/, 'text/html' ]
			[ /\.css$/, 'text/css' ]
			[ /\.png$/, 'image/png' ]
			[ /\.(jpg|jpeg)$/, 'image/jpg' ]
			[ /\.gif$/, 'image/gif' ]
		]
		for f in fileType
			if fileName.match f[0]
				return f[1]
		console.log 'Unknown content type of ' + fileName

	fileName = req.url
	if fileName is '/'
		fileName = '/index.html'

	contentType = getContentType fileName

	fileName = PUBLIC_PATH + fileName

	fileSending = (err, data) ->
		if err
			console.log 'Err  ' + fileName + ' : ' + err
			res.writeHead 404
			res.write '404 file Not found'
			res.end()
			return

		res.writeHead 200,
			'Content-Length': data.length
			'Content-Type': contentType
		res.write data
		res.end()
		return

	fs.readFile fileName, fileSending
	return

http.createServer(serverMain).listen(constants.HTTP_PORT)

world = new wwwar.World()
allCount = 0
ondisconnection = ->
	socket = @
	console.log 'No.' + socket.no + ': has disconnected.'
oninput = (data) ->
	socket = @
	console.log 'No.' + socket.no + ': input ' + util.inspect(data)
	world.addInput socket.no, data
onrequestallsnapshot = (data) ->
	socket = @
	console.log 'No.' + socket.no + ': requested all snapshot'
onconnection = (socket) ->
	io = @
	console.log 'No.' + allCount + ': has connected.'
	socket.no = allCount++
	world.addUser socket.no

	socket.broadcast.emit constants.PROTOCOL.SC.NEW_CONNECTION, 'No. ' + socket.no + ': has connected.'

	socket.on constants.PROTOCOL.CS.INIT, (data) -> console.log 'No. ' + socket.no + ': ' + data
	socket.on constants.PROTOCOL.CS.INPUT, oninput
	socket.on constants.PROTOCOL.CORE.DISCONNECTION, ondisconnection
	socket.on constants.PROTOCOL.CS.REQUEST_ALL_SNAPSHOT, onrequestallsnapshot
	socket.emit constants.PROTOCOL.SC.REQUEST_INPUT_START, '1'
c = Connector.singleton()
c.connect onconnection

console.log '========================================'
console.log 'Start wa-wa-war server at ' + constants.HTTP_PORT
console.log '========================================'

tickWorld = ->
	world.tick()
	setTimeout tickWorld, constants.SERVER_TICK_MS
tickWorld()
sendSnapshot = ->
	c.emit constants.PROTOCOL.SC.SNAPSHOT, world.makeSnapshot()
	setTimeout sendSnapshot, constants.SERVER_SEND_MS
sendSnapshot()
