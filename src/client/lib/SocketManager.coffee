class SocketManager
	constructor: ->
		@buffer = [] # 未送信データ配列
		@onInitialData = -> {}
		@onSendSnapshot = -> {}
		return

	start: ->
		if !io?
			console.log 'socket.io not found'
			return @

		@socket = io SOCKET_ADDR
		@isRunning = true
		me = @
		@socket.on PROTOCOL.SC.INITIAL_DATA, @onInitialData
		@socket.on PROTOCOL.SC.SEND_SNAPSHOT, @onSendSnapshot
		return @

	addBuffer: (buff) ->
		@buffer.push buff

	sendInput: ->
		if @socket.connected and @buffer.length > 0
			@socket.emit PROTOCOL.CS.SEND_INPUT, @buffer
			@buffer = []

	@singleton: ->
		if !SocketManager._instance?
			SocketManager._instance = new SocketManager()
		return SocketManager._instance
