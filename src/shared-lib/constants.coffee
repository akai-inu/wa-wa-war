globalobj = null
if typeof module is 'undefined'
	globalobj = window
else
	globalobj = exports

define = (name, value) ->
	Object.defineProperty globalobj, name,
		value: value
		enumerable: true

define 'HTTP_PORT', 9292
define 'WEBSOCKET_PORT', 9293

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
