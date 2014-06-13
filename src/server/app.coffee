constants = require './lib/constants.js'
http = require 'http'
fs = require 'fs'

APP_PATH = __dirname + '/..'
PUBLIC_PATH = APP_PATH + '/public'

serverMain = (req, res) ->
	getContentType = (fileName) ->
		fileType = [
			[ /\.js$/, 'text/javascript' ]
			[ /\.html$/, 'text/html' ]
			[ /\.css$/, 'text/css' ]
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

console.log '========================================'
console.log 'Start wa-wa-war server at ' + constants.HTTP_PORT
console.log '========================================'
