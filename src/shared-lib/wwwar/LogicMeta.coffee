if module?
	util = require 'util'
	LogicBase = require './LogicBase'

class LogicMeta extends LogicBase
	constructor: ->
		super()
		@tickNo = -1
		@tickTime = -1
		@elapsedTime = -1
		return

	deserialize: (serialized) ->
		@tickNo = serialized[0]
		@tickTime = serialized[1]
		@elapsedTime = serialized[2]
		return

	serialize: ->
		return [
			@tickNo
			@tickTime
			@elapsedTime
		]

if module?
	module.exports = LogicMeta
