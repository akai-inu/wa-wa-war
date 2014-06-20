((globalobj) ->
	define = (name, value) ->
		Object.defineProperty globalobj, name,
			value: value
			enumerable: true

	define 'HTTP_PORT', 9292
	define 'TCP_PORT', 9293

	# socket
	define 'SOCKET_ADDR', 'http://cafe-capy.net:' + globalobj.TCP_PORT
	define 'SERVER_TICK_MS', 1000 / 30
	define 'SERVER_SEND_MS', 1000 / 15
	define 'CLIENT_SEND_MS', 1000 / 15

	# TCP Protocol Definition
	define 'PROTOCOL',
		# socket.io default
		CORE:
			CONNECTION: 'connection'
			DISCONNECTION: 'disconnect'

		# client to server
		CS:
			INIT: 100
			INPUT: 101
			REQUEST_ALL_SNAPSHOT: 102

		# server to client
		SC:
			NEW_CONNECTION: 200
			LEAVE_CONNECTION: 201
			REQUEST_INPUT_START: 202
			REQUEST_INPUT_STOP: 203
			ALL_SNAPSHOT: 204
			SNAPSHOT: 205

	# client
	define 'GAME_FPS', 30
	define 'GAME_WIDTH', 854
	define 'GAME_HEIGHT', 480
	define 'GAME_CENTERX', Math.floor(globalobj.GAME_WIDTH / 2)
	define 'GAME_CENTERY', Math.floor(globalobj.GAME_HEIGHT / 2)
	define 'IMG_PATH', '/img'
	define 'RESOURCES', [
		'img/player.png'
	]
	define 'BIND_KEYS',
		'W': 'W'
		'S': 'S'
		'A': 'A'
		'D': 'D'
		' ': 'Space'
	define 'KEY_FLAGS',
		left:  1 << 0
		right: 1 << 1
		up:    1 << 2
		down:  1 << 3
		A:     1 << 4
		D:     1 << 5
		W:     1 << 6
		S:     1 << 7
		Space: 1 << 8

)(if module? then exports else window)
