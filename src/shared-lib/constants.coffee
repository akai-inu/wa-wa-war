globalobj = if module? then module.exports else window

define = (name, value) ->
	Object.defineProperty globalobj, name,
		value: value
		enumerable: true

define 'VERSION', '0.0.1'

# server
define 'ADDR', 'http://cafe-capy.net'
define 'HTTP_PORT', 9292
define 'HTTP_ADDR', globalobj.ADDR + ':' + globalobj.HTTP_PORT
define 'LIMIT_CONNECTION', 200
if process?
	define 'START_HR_TIME', process.hrtime()


# socket
define 'SOCKET_PORT', 9293
define 'SOCKET_ADDR', 'http://cafe-capy.net:' + globalobj.SOCKET_PORT
define 'TICK_MS', 1000 / 1
define 'SERVER_SEND_MS', 1000 / 1
define 'CLIENT_SEND_MS', 1000 / 1

# TCP Protocol Definition
define 'PROTOCOL',
	# socket.io default
	CORE:
		CONNECTION: 'connection'
		DISCONNECTION: 'disconnect'

	# client to server
	CS:
		SEND_INPUT: 100 # 入力送信
	# server to client
	SC:
		INITIAL_DATA: 200 # [uid, Snapshot]サーバ接続時初期化データ
		SEND_SNAPSHOT: 201

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
