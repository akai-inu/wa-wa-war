((globalobj) ->
	define = (name, value) ->
		Object.defineProperty globalobj, name,
			value: value
			enumerable: true

	define 'HTTP_PORT', 9292
	define 'TCP_PORT', 9293

	# socket
	define 'SERVER_TICK_MS', 1000 / 0.5
	define 'SERVER_SEND_MS', 1000 / 0.5
	define 'CLIENT_SEND_MS', 1000 / 0.5

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
	define 'BINDKEYS',
		'W': 'W'
		'S': 'S'
		'A': 'A'
		'D': 'D'
		' ': 'Space'

)(if module? then exports else window)
