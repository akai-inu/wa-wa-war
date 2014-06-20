SceneMain = enchant.Class.create enchant.Scene,
	initialize: ->
		enchant.Scene.call @

		@inputFlagsBuffer = [] # 入力フラグの変化リスト(未送信分)
		@inputFlagsBuffer.push [0, 0]
		@lastInput = 0
		@users = []

		# 入力フラグの取得メソッド作成
		if !game.input.getInputFlags?
			game.input.getInputFlags = ->
				flags = 0
				for key, flag of KEY_FLAGS
					if game.input[key]? and game.input[key] is true
						flags += flag
				return flags

		c = Connector.singleton()
		c.connect()
		me = @
		c.on PROTOCOL.SC.REQUEST_INPUT_START, (data) ->
			me.sendInput = true
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

		c.emit PROTOCOL.CS.INIT, 'some client init data'

		sendInputFunc = ->
			if me.sendInput and me.inputFlagsBuffer.length isnt 0
				c.emit PROTOCOL.CS.INPUT, me.inputFlagsBuffer
				console.log 'sent ' + me.inputFlagsBuffer
				me.inputFlagsBuffer = []
			setTimeout sendInputFunc, CLIENT_SEND_MS
		sendInputFunc()
		return

	onenterframe: ->
		c = Connector.singleton()
		nowInput = game.input.getInputFlags()
		if @lastInput isnt nowInput
			@lastInput = nowInput
			@inputFlagsBuffer.push [c.getElapsedMs(), nowInput]
