class SocketManager
	constructor: ->
		@buffer = [] # 未送信データ配列
		return

	start: ->
		if !io?
			console.log 'socket.io not found'
			return @

		@socket = io SOCKET_ADDR
		@isRunning = true
		me = @
		@socket.on PROTOCOL.SC.INITIAL_DATA, (data) =>
			me.onInitialData data[0], data[1]
		@socket.on PROTOCOL.SC.SEND_SNAPSHOT, (data) =>
			me.onSendSnapshot data
		return @

	addBuffer: (buff) ->
		@buffer.push buff

	sendInput: ->
		if @socket.connected and @buffer.length > 0
			@socket.emit PROTOCOL.CS.SEND_INPUT, @buffer
			@buffer = []

	onInitialData: (uid, snapshot) =>
		console.log 'uid = ' + uid
		w = new LogicWorld()
		w.deserialize snapshot
		console.log w

	onSendSnapshot: (snapshot) =>
		w = new LogicWorld()
		w.deserialize snapshot
		console.log w

	@singleton: ->
		if !SocketManager._instance?
			SocketManager._instance = new SocketManager()
		return SocketManager._instance
