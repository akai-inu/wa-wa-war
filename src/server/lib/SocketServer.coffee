# requirement
util = require 'util'
io = require 'socket.io'
c = require './constants'
PROTOCOL = c.PROTOCOL
Logger = require './Logger'
tick = require('./Tick').singleton()
snapshot = require('./SnapshotHolder').singleton()

###
# TCP Socket Server
###
class SocketServer
	isRunning: false
	serverStartHrTime: []
	totalCount: 0
	nowCount: 0

	constructor: ->
		@socketList = {}
		# UIDがキーのソケット一覧

	# TCPのリッスンを開始する
	start: ->
		@io = io.listen c.SOCKET_PORT
		# サーバ開始時間取得
		@serverStartHrTime = process.hrtime()
		@isRunning = true
		@io.on PROTOCOL.CORE.CONNECTION, @onConnection
		tick.startTick()

		me = @
		sendSnapshot = ->
			ss = snapshot.getLast()
			if me.nowCount isnt 0 and ss?
				me.io.emit PROTOCOL.SC.SEND_SNAPSHOT, snapshot.getLast()
			setTimeout sendSnapshot, c.SERVER_SEND_MS
			return
		sendSnapshot()
		return

	onConnection: (socket) =>
		# ユーザID生成
		uid = @generateUniqueId()

		if !@addUser uid
			# Worldへのユーザー追加に失敗
			Logger.error 'UID:%s cannot add User', uid
			socket.disconnect()
			return

		socket.uid = uid
		@socketList[uid] = socket

		Logger.info 'UID:%s has connected NOW:%s/%s TOTAL:%s', uid, @nowCount, c.LIMIT_CONNECTION, @totalCount

		socket.emit PROTOCOL.SC.INITIAL_DATA, [uid, snapshot.getLast()]

		# イベントハンドラ設定
		socket.on PROTOCOL.CORE.DISCONNECTION, =>
			@onDisconnection socket
		socket.on PROTOCOL.CS.SEND_INPUT, (data) =>
			@onSendInput socket, data

		return

	onDisconnection: (socket) =>
		if !@removeUser socket.uid
			Logger.error 'UID:%s cannot remove User', socket.uid
			return

		Logger.info 'UID:%s has disconnected NOW:%s/%s TOTAL:%s', socket.uid, @nowCount, c.LIMIT_CONNECTION, @totalCount
		return

	onSendInput: (socket, data) =>
		Logger.debug 'Received Input uid=%s data=%s', socket.uid, data

	addUser: (uid) =>
		if !tick.currentWorld.userManager.addUser uid
			return false

		@nowCount++
		@totalCount++

		return true

	removeUser: (uid) =>
		if !tick.currentWorld.userManager.removeUser uid
			return false

		@socketList[uid] = null
		@nowCount--
		return true

	###
	onconnectionOld: (socket) ->
		# 新規接続
		sv = SocketServer.singleton()
		io = @
		uid = sv.generateUniqueId()

		sv.nowCount++
		sv.totalCount++

		Logger.info '%s has connected. now = %s, total = %s', uid, sv.nowCount, sv.totalCount
		world.addUser uid

		# emit
		socket.emit PROTOCOL.SC.REQUEST_INPUT_START, [uid, sv.nowTickNo]
		socket.broadcast.emit PROTOCOL.SC.NEW_CONNECTION, uid

		socket.on PROTOCOL.CORE.DISCONNECTION, ->
			sv.nowCount--
			Logger.debug '%s has disconnected. now = %s, total = %s', uid, sv.nowCount, sv.totalCount

		socket.on PROTOCOL.CS.INPUT, (data) ->
			Logger.debug 'received %s input data : length = %s', uid, JSON.stringify(data).length
			world.addInput uid, data

		socket.on PROTOCOL.CS.REQUEST_ALL_SNAPSHOT, (data) ->
			Logger.debug '%s has requested all snapshot'
			# TODO: send all snapshot
			#socket.emit PROTOCOL.SC.ALL_SNAPSHOT, world.makeAllSnapshot()

	startOld: ->
		conn.connect @onconnection
		me = @
		tick = ->
			me.lastTick = conn.getServerTime()
			world.tick()
			Logger.debug 'Tick %s', me.nowTickNo
			me.nowTickNo++
			setTimeout tick, constants.TICK_MS
		tick()
		snapshot = ->
			if me.nowCount isnt 0
				me.lastSnapshot = conn.getServerTime()
				ss = world.makeSnapshot()
				me.snapshotLog.push [me.lastSnapshot, ss]
				if me.snapshotLog.length > Math.floor(1000 / constants.SERVER_SEND_MS) * 5 + 1
					me.snapshotLog.shift()
				conn.io.emit constants.PROTOCOL.SC.SNAPSHOT, ss
				Logger.debug 'Snapshot %s', me.nowSnapshotNo
				me.nowSnapshotNo++
			setTimeout snapshot, constants.SERVER_SEND_MS
		snapshot()

		return @
	###

	# ソケット通信が利用可能か取得する
	checkAvailable: ->
		if !@isRunning
			return false

		return true

	# ユニークなユーザIDを割り振る
	generateUniqueId: ->
		# uidは 0～LIMIT_CONNECTION

		if @nowCount >= c.LIMIT_CONNECTION
			Logger.error 'Limit Connection Over NOW:%s/%s', @nowCount, c.LIMIT_CONNECTION
			return -1

		generated = false
		uid = -1
		while !generated
			uid = Math.floor(Math.random() * c.LIMIT_CONNECTION)
			generated = true
			for id, socket of @socketList
				if socket isnt null and id is uid
					generated = false
					break
		return uid

	# 接続開始からの経過時間を取得する
	getElapsedms: ->
		if @serverStartHrTime.length isnt 2
			return 0
		delta = process.hrtime(@serverStartHrTime)
		secms = t[0] * 1000
		nsecms = t[1] / 1000000
		return Math.floor secms + nsecms

	@singleton: ->
		if !SocketServer._instance?
			SocketServer._instance = new SocketServer()
		return SocketServer._instance

module.exports = SocketServer
