SceneTitle = enchant.Class.create enchant.Scene,
	initialize: ->
		enchant.Scene.call @
		console.log window.World.TEST

		socket = io 'http://cafe-capy.net:9293'
		socket.on 'newConnection', (data) ->
			console.log data
		socket.on 'snapshot', (data) ->
			console.log data
		socket.on 'leaveConnection', (data) ->
			console.log data

		sendInput = ->
			socket.emit 'input',
				left: game.input.left
				right: game.input.right
				up: game.input.up
				down: game.input.down
			setTimeout sendInput, CLIENT_SEND_MS
		sendInput()
		return
