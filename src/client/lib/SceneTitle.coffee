SceneTitle = enchant.Class.create enchant.Scene,
	initialize: ->
		enchant.Scene.call @
		connector = Connector.singleton()

		connector.getInputFlags = ->
			flags = 0
			for key, flag of KEY_FLAGS
				if game.input[key]? and game.input[key] is true
					flags += flag
			return flags

		connector.connect()
		connector.emit PROTOCOL.CS.INIT, 'some client init data.'
		return

	onenterframe: ->
		performance.now()
