c = {}
define = (name, value) ->
	Object.defineProperty c, name,
		value: value
		enumerable: true
	if !module?
		Object.defineProperty window, name,
			value: value
			enumerable: true

define 'VERSION', '0.0.1'

define 'IS_SERVER', module?
define 'ENVIRONMENT', 'development'

# server
define 'ADDR', 'http://cafe-capy.net'
define 'HTTP_PORT', 9292
define 'HTTP_ADDR', c.ADDR + ':' + c.HTTP_PORT
define 'LIMIT_CONNECTION', 200
if module?
	define 'START_HR_TIME', process.hrtime()
else
	define 'START_TIME', performance.now()


# socket
define 'SOCKET_PORT', 9293
define 'SOCKET_ADDR', 'http://cafe-capy.net:' + c.SOCKET_PORT
define 'TICK_MS', 1000 / 2
define 'SERVER_SEND_MS', 1000 / 1
define 'CLIENT_SEND_MS', 1000 / 1
define 'CLIENT_INTERPOLATE_MS', 80
define 'CLIENT_SNAPSHOT_HOLD', 10 # クライアントのスナップショット保持数
define 'SERVER_SNAPSHOT_HOLD', 10 # サーバのスナップショット保持数

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
define 'GAME_CENTERX', Math.floor(c.GAME_WIDTH / 2)
define 'GAME_CENTERY', Math.floor(c.GAME_HEIGHT / 2)
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

if module? then module.exports = c else window.c = c
