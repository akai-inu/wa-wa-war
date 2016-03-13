###
# Wa-Wa-War Logic User Class
###
if require?
	c = require __dirname + '/../Constants'
	KEY_FLAGS = c.KEY_FLAGS
	LogicBase = require __dirname + '/LogicBase'

class LogicUser extends LogicBase
	constructor: (@uid) ->
		@x = 100
		@y = 100
		@angle = 0
		@lastInput = 0
		@inputBuffer = []

	applyInput: (inputList) ->
		for input in inputList
			@inputBuffer.push input

	tick: ->
		if @inputBuffer.length is 0
			# 最終入力を流用
			@move @lastInput[1]
		else
			# 最新入力の追加
			for input in @inputBuffer
				@move input[1]
			@lastInput = @inputBuffer.pop()
			@inputBuffer = []

	move: (flags) ->
		if flags & KEY_FLAGS.left
			@angle -= 5
		if flags & KEY_FLAGS.right
			@angle += 5

		if flags & KEY_FLAGS.A
			@x -= 5
		if flags & KEY_FLAGS.D
			@x += 5
		if flags & KEY_FLAGS.W
			@y -= 5
		if flags & KEY_FLAGS.S
			@y += 5

	deserialize: (serialized) ->
		@uid = serialized[0]
		@x = serialized[1]
		@y = serialized[2]
		@angle = serialized[3]

	serialize: ->
		return [
			@uid
			@x
			@y
			@angle
		]

module.exports = LogicUser if module?
