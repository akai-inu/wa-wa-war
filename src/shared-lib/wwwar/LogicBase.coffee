###
# Wa-Wa-War Logic Base Class
###
if module?
	Logger = require __dirname + '/../Logger'

class LogicBase
	constructor: ->
		@elements = []
		@isServer = module?
		return

	# 子要素追加
	add: (logic) ->
		if !logic.add?
			Logger.error '%s Invalid Elements detected when adding Logic elements', @constructor.name
		@elements.push logic
		return @

	# 子要素削除
	remove: (logic) ->
		for c, i in @elements
			if c is logic
				removed = @elements.splice i, 1
				return removed
		Logger.error '%s No Child found.', @constructor.name
		return

	# サーバ上のロジック更新処理
	tick: ->
		if !@isServer
			console.log 'client can\'t use #tick'
			return
		for c, i in @elements
			c.tick()
		return

	# serializedデータをインスタンス変数に展開(クライアント用)
	deserialize: (serialized) ->
		for c, i in @elements
			c.deserialize(serialized[i])

	# インスタンス変数をserialize(サーバ用)
	serialize: ->
		if !@isServer
			console.log 'client can\'t use #serialize'
			return

		serialized = []
		for c, i in @elements
			if c?
				serialized.push c.serialize()
		return serialized

if module?
	module.exports = LogicBase
