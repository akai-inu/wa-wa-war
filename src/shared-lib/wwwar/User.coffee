###
# Wa-Wa-War Logic User Class
###
if module?
	LogicBase = require __dirname + '/LogicBase'

class User extends LogicBase
	constructor: ->
		@x = Math.floor(Math.random() * 800 + 20)
		@y = 0
		@angle = 0

	tick: ->
		@y += Math.floor(Math.random() * 5)

	makeSnapshot: ->
		return {x: @x, y: @y, angle: @angle}

if module?
	module.exports = User
else
	window.wwwar = window.wwwar || {}
	window.wwwar.User = User
