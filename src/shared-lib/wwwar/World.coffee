###
# Wa-Wa-War Logic World Data Class
###
if module?
	LogicBase = require __dirname + '/LogicBase'
	UserManager = require __dirname + '/UserManager'

class World extends LogicBase
	constructor: ->
		@userManager = new UserManager()
		return

	addUser: (number) ->
		@userManager.addUser(number)

	removeUser: (number) ->
		@userManager.removeUser(number)

	addInput: (number, inputList) ->
		@userManager.addInput number, inputList

	tick: ->
		@userManager.tick()

	makeSnapshot: ->
		return @userManager.makeSnapshot()

if module?
	module.exports = World
else
	window.wwwar = window.wwwar || {}
	window.wwwar.World = World
