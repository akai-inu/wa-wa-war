if require?
	util = require 'util'
	fs = require 'fs'
	c = require './Constants'

class Logger
	@LEVEL:
		ERROR: 'error'
		WARNING: 'warning'
		INFO: 'info'
		DEBUG: 'debug'

	@log: (level, args) ->
		d = Logger.getDate()
		Logger.defaultPath = Logger.stringReplacer 'wa-wa-war-%s-%s-%s.log', d.y, d.m, d.d
		args = Array.prototype.slice.call args

		# argument 確認
		if args.length is 0
			throw 'Logger.log : invalid arguments'
			return
		format = args.shift()

		# リリース環境ではDEBUGログは出力しない
		if c.ENVIRONMENT is 'release' and level is Logger.LEVEL.DEBUG
			return ''

		strList = []

		# ログ時間
		strList.push Logger.stringReplacer('%s/%s/%s %s:%s:%s', d.y, d.m, d.d, d.h, d.i, d.s)

		# 開始からの経過時間
		if c.IS_SERVER
			hrtime = process.hrtime c.START_HR_TIME
			strList.push Math.floor(hrtime[0] * 1000 + hrtime[1] / 1000000)
		else
			now = performance.now()
			strList.push Math.floor now - c.START_TIME

		# ログレベル
		strList.push '[' + level + ']'

		# ログ内容
		str = Logger.stringReplacer format, args
		strList.push str

		logStr = strList.join '\t'

		# console.log
		if !c.IS_SERVER or process.env.NODE_ENV is 'development'
			console.log logStr

		# logfile書き込み
		if c.IS_SERVER
			require('fs').appendFile Logger.defaultPath, logStr + '\n', (err) ->
				if (err) then console.log 'Log Append Failed : ' + err

		return logStr

	@error: ->
		Logger.log Logger.LEVEL.ERROR, arguments
	@warning: ->
		Logger.log Logger.LEVEL.WARNING, arguments
	@info: ->
		Logger.log Logger.LEVEL.INFO, arguments
	@debug: ->
		Logger.log Logger.LEVEL.DEBUG, arguments

	@getDate: ->
		date = new Date()
		date.y = date.getFullYear()
		date.m = date.getMonth()
		date.d = date.getDate()
		date.h = date.getHours()
		date.i = date.getMinutes()
		date.s = date.getSeconds()
		return date

	@stringReplacer: ->
		args = Array.prototype.slice.call arguments

		if args.length is 0
			throw 'Logger.stringReplacer : arguments is null'
			return ''

		format = args.shift()

		if args.length is 0
			return format

		if args.length is 1 and Array.isArray args[0]
			args = args[0]

		rep_fn = ->
			return if args.length is 0 then '' else args.shift()
		str = format.replace /%s/g, rep_fn
		return str

if module? then module.exports = Logger
