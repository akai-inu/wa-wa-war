###
# Wa-Wa-War Logic User Class
###
if module?
	constants = require __dirname + '/../constants'
	LogicBase = require __dirname + '/LogicBase'

class User extends LogicBase
	constructor: ->
		@x = constants.GAME_WIDTH / 2
		@y = constants.GAME_HEIGHT / 2
		@angle = 0
		@lastInput = 0
		@inputBuffer = []

	addInput: (inputArray) ->
		for input in inputArray
			@inputBuffer.push input

	tick: ->
		if @inputBuffer.length is 0
			# 最終入力の補間
			@move @lastInput[1]
		else
			# 最新入力の追加
			for input in @inputBuffer
				@move input[1]
			@lastInput = @inputBuffer.pop()
			@inputBuffer = []

	move: (flags) ->
		if flags & constants.KEY_FLAGS.left
			@angle -= 5
		if flags & constants.KEY_FLAGS.right
			@angle += 5

		if flags & constants.KEY_FLAGS.A
			@x -= 5
		if flags & constants.KEY_FLAGS.D
			@x += 5
		if flags & constants.KEY_FLAGS.W
			@y -= 5
		if flags & constants.KEY_FLAGS.S
			@y += 5

	makeSnapshot: ->
		return {x: @x, y: @y, angle: @angle}

if module?
	module.exports = User
else
	window.wwwar = window.wwwar || {}
	window.wwwar.User = User
