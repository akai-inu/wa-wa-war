constants = require __dirname + '/constants'
io = require 'socket.io'

class Connector
	constructor: ->
		return

	connect: (onconnection) ->
		@io = io.listen constants.TCP_PORT

		if !onconnection?
			throw 'ソケット接続時コールバックを指定する必要があります'
		@io.on 'connection', onconnection

		return

	emit: (protocol, data) ->
		@io.emit protocol, data
		return

	onconnection: (socket) =>
		console.log socket.id + ' has connected.'
		socket.broadcast.emit constants.PROTOCOL.SC.NEW_CONNECTION, socket.id + ' has connected.'
		socket.connector = @
		socket.on constants.PROTOCOL.CORE.DISCONNECTION, @ondisconnect
		socket.on constants.PROTOCOL.CS.INPUT, @onReceive
		@idData[socket.id] = true

	ondisconnect: ->
		socket = @
		console.log socket.id + ' has disconnected.'
		socket.broadcast.emit constants.PROTOCOL.SC.LEAVE_CONNECTION, socket.id + ' has disconnected.'
		socket.connector.idData[socket.id] = false

Connector.singleton = ->
	if !Connector._instance?
		Connector._instance = new Connector()
	return Connector._instance
module.exports = Connector
