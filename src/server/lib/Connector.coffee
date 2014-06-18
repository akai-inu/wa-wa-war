constants = require __dirname + '/constants'
io = require 'socket.io'

class Connector
	constructor: ->
		@listener = io.listen(constants.TCP_PORT)
		@listener.on 'connection', @onconnection

		@idData = {}
		@onReceive = -> {}

		return

	sendSnapshot: (snapshot) ->
		@listener.emit 'snapshot', snapshot

	onconnection: (socket) =>
		console.log socket.id + ' has connected.'
		socket.broadcast.emit 'newConnection', socket.id + ' has connected.'
		socket.connector = @
		socket.on 'disconnect', @ondisconnect
		socket.on 'input', @onReceive
		@idData[socket.id] = true

	ondisconnect: ->
		socket = @
		console.log socket.id + ' has disconnected.'
		socket.broadcast.emit 'leaveConnection', socket.id + ' has disconnected.'
		socket.connector.idData[socket.id] = false

module.exports = Connector
