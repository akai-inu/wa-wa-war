util = require 'util'
fs = require 'fs'
c = require './constants'

Logger = Logger || {}
Logger.logPath = 'default.log'
Logger.LEVEL =
	ERROR: 'error'
	INFO: 'info'
	DEBUG: 'debug'
Logger.parseArgs = (level, args) ->
	args = Array.prototype.slice.call(args)

	if args.length is 0
		throw 'Logger.log : invalid arguments length=' + args.length

	fmt = args.shift()

	if level is Logger.LEVEL.DEBUG and process.env.NODE_ENV isnt 'development'
		return ''

	strList = []
	date = new Date()
	y = date.getFullYear()
	m = date.getMonth()
	d = date.getDate()
	h = date.getHours()
	i = date.getMinutes()
	s = date.getSeconds()
	strList.push(y + '/' + m + '/' + d + ' ' + h + ':' + i + ':' + s)

	serverHrTime = process.hrtime(c.START_HR_TIME)
	strList.push(Math.round(serverHrTime[0] * 1000 + serverHrTime[1] / 1000000))
	strList.push('[' + level + ']')

	if args.length is 0
		strList.push fmt
		return strList.join '\t'

	val = args
	rep_fn = (m, k) ->
		val.shift()
	str = fmt.replace /%s/g, rep_fn
	strList.push str
	return strList.join '\t'

Logger.log = (level, args) ->
	str = Logger.parseArgs level, args
	if str is ''
		return

	if process.env.NODE_ENV is 'development'
		console.log str
	fs.appendFile Logger.logPath, str + '\n', (err) ->
		if (err)
			throw err
	return str
Logger.error = ->
	Logger.log Logger.LEVEL.ERROR, arguments
Logger.info = ->
	Logger.log Logger.LEVEL.INFO, arguments
Logger.debug = ->
	Logger.log Logger.LEVEL.DEBUG, arguments

module.exports = Logger
