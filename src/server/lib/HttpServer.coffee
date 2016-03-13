fs = require 'fs'
c = require './Constants'
Logger = require './Logger'

APP_PATH = __dirname + '/../..'
PUBLIC_PATH = APP_PATH + '/public'

class HttpServer
	@getContentType: (fileName) ->
		# Content-Typeの決定
		fileTypeList = [
			[ /\.js$/, 'text/javascript' ]
			[ /\.(htm|html)$/, 'text/html' ]
			[ /\.css$/, 'text/css' ]
			[ /\.png$/, 'image/png' ]
			[ /\.(jpg|jpeg)$/, 'image/jpg' ]
			[ /\.gif$/, 'image/gif' ]
			[ /\.ico$/, 'image/x-icon' ]
		]
		for f in fileTypeList
			if fileName.match f[0]
				return f[1]

		Logger.info 'Unknown content type of %s', fileName
		return 'text/plain'

	@getFileName: (url) ->
		# 呼び出しファイル名の決定
		url = if url is '/' then '/index.html' else url
		url = PUBLIC_PATH + url
		return url

	start: ->
		require('http').createServer(@listener).listen(c.HTTP_PORT)
		return @

	listener: (req, res) ->
		fileName = HttpServer.getFileName req.url
		contentType = HttpServer.getContentType fileName

		# ファイル読み込みコールバック
		readFile = (err, content) ->
			if err
				Logger.error fileName + ' has error : ' + err
				res.writeHead 500
				res.write '500 Error\n' + err
				res.end()
				return

			res.writeHead 200,
				'Content-Length': content.length
				'Content-Type': contentType
			res.write content
			res.end()
			return

		# ファイル確認コールバック
		exists = (exists) ->
			if exists
				fs.readFile fileName, readFile
				return

			Logger.info fileName + ' not found'
			res.writeHead 404,
				'Content-Type': 'text/plain'
			res.write '404 Error\n' + fileName + ' isnt exists.'
			res.end()
			return

		fs.exists fileName, exists
		return

	@singleton: ->
		if !HttpServer._instance?
			HttpServer._instance = new HttpServer()
		return HttpServer._instance

module.exports = HttpServer
