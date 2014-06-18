###
# Wa-Wa-War Logic UserManager Class
###
if module?
	LogicBase = require __dirname + '/LogicBase'
	User = require __dirname + '/User'

class UserManager extends LogicBase
	constructor: ->
		@users = []

	addUser: ->
		@users.push new User()

	tick: ->
		@users.forEach (user) ->
			user.tick()

	makeSnapshot: ->
		snapshot = []
		@users.forEach (user) ->
			snapshot.push user.makeSnapshot()
		return snapshot

if module?
	module.exports = UserManager
else
	window.wwwar = window.wwwar || {}
	window.wwwar.UserManager = UserManager
