Connector = enchant.Class.create
	initialize: ->
		if io?
			@enabled = true

		@connectTimeMs = 0
		return

	connect: ->
		if !@enabled
			console.log 'socket.ioが見つかりません'
			return

		@socket = io SOCKET_ADDR
		@connectTimeMs = performance.now()
		@connected = true
		return

	emit: (protocol, data) ->
		if !@socket?
			console.log 'socket.ioが接続されていません'
			return

		@socket.emit protocol, data

	on: (protocol, func) ->
		if !@socket?
			console.log 'socket.ioが接続されていません'
			return

		@socket.on protocol, func

	getElapsedMs: ->
		Math.floor(performance.now() - @connectTimeMs)

Connector.singleton = ->
	if !Connector._instance?
		Connector._instance = new Connector()
	return Connector._instance
