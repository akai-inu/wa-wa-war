###
# Wa-Wa-War Logic Base Class
###
if require?
	Logger = require __dirname + '/../Logger'

class LogicBase
	constructor: ->
		@elements = []
		@parent = null
		@isServer = module?
		return

	# 子要素追加
	add: (logic) ->
		if !logic.add?
			Logger.error '%s Invalid Elements detected when adding Logic elements', @constructor.name
		logic.parent = @
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
	simulate: ->
		if !@isServer
			Logger.error 'client can\'t use #simulate'
			return
		for c, i in @elements
			c.simulate()
		return

	# 2スナップショットのデータを元にデータを補間
	interpolate: (ssPrev, ssNext, elapsed) ->
		if lerpVal >= 1.0
			for c, i in @elements
				c.extrapolate ssPrev, ssNext
			return

		for c, i in @elements
			c.interpolate ssPrev, ssNext, lerpVal
		return

	extrapolate: (ssPrev, ssNext) ->
		for c, i in @elements
			c.extrapolate ssPrev, ssNext
		return

	# インスタンス変数をserialize
	serialize: ->
		serialized = []
		for c, i in @elements
			if c?
				serialized.push c.serialize()
		return serialized

module.exports = LogicBase if module?
