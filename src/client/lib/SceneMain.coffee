SceneMain = enchant.Class.create enchant.Scene,
	initialize: ->
		enchant.Scene.call @
		@backgroundColor = '#fff'
		@users = {}
		@logic = null # 現在動いているロジックツリー
		socketManager = SocketManager.singleton()
		ss = SnapshotHolder.singleton()
		me = @

		# 現在の入力フラグを取得
		@getInputFlags = ->
			flags = 0
			for key, flag of KEY_FLAGS
				if game.input[key]? and game.input[key] is true
					flags += flag
			return flags

		# SC.INITIAL_DATA 受信時のコールバック設定
		socketManager.onInitialData = (data) ->
			me.uid = data[0]
			ss.add data[1]
			me.logic = new LogicWorld()
			me.logic.interpolate ss.getLatest(), ss.getLatest(), 0
			Logger.debug 'uid = ' + me.uid + ', snapshot = ' + ss.getLatest()
			return

		# SC.SEND_SNAPSHOT 受信時のコールバック設定
		socketManager.onSendSnapshot = (snapshot) ->
			ss.add snapshot
			Logger.debug 'tickNo = ' + ss.getLatestMeta()[0]
			return

		# ソケット開始
		socketManager.start()

		# Tick処理
		tick = ->
			latestMeta = ss.getLatestMeta()
			ssNo = if latestMeta? then latestMeta[0] else 0
			elapsed = ss.getCalculatedServerTime

			# 送信内容をバッファに追加
			socketManager.addBuffer [ssNo, elapsed, me.getInputFlags()]
			setTimeout tick, TICK_MS
			return

		# CS.SEND_INPUT 処理
		sendInput = ->
			socketManager.sendInput()
			setTimeout sendInput, CLIENT_SEND_MS
			return
		tick()
		sendInput()
		###
		me = @
		c.on PROTOCOL.SC.NEW_CONNECTION, (data) ->
		c.on PROTOCOL.SC.REQUEST_INPUT_START, (data) ->
			me.uid = data
			console.log me.uid + '番兵！よく戦場に来た！歓迎するぞ！'
			# エンティティ生成
			me.sendInput = true
			me.myEntity = new enchant.Entity()
			me.myEntity.backgroundColor = '#f00'
			me.myEntity.width = 32
			me.myEntity.height = 32
			me.myEntity.uid = me.uid
			me.addChild me.myEntity
			me.users[me.uid] = me.myEntity
		c.on PROTOCOL.SC.REQUEST_INPUT_STOP, (data) ->
			me.sendInput = false
		c.on PROTOCOL.SC.SNAPSHOT, (data) ->
			for user in data
				uid = user[0]
				if !me.users[uid]?
					e = new enchant.Entity()
					e.backgroundColor = '#fff'
					e.width = 50
					e.height = 50
					e.uid = uid
					me.addChild e
					me.users[uid] = e
				me.users[uid].x = user[1].x
				me.users[uid].y = user[1].y
				me.users[uid].rotation = user[1].angle
				me.users[uid].updated = true

			for uid, user of me.users
				if not user.updated
					user.remove()

		@tickNum = 0
		tick = ->
			nowInput = game.input.getInputFlags()
			if me.lastInput isnt nowInput
				me.lastInput = nowInput
				me.inputFlagsBuffer.push nowInput
			setTimeout tick, TICK_MS
		tick()
		sendInputFunc = ->
			if me.sendInput and me.inputFlagsBuffer.length isnt 0
				c.emit PROTOCOL.CS.SEND_INPUT, me.inputFlagsBuffer
				console.log Connector.singleton().getClientTime() + 'ms sent ' + me.inputFlagsBuffer
				me.inputFlagsBuffer = []
			setTimeout sendInputFunc, CLIENT_SEND_MS
		sendInputFunc()
		return
		###
