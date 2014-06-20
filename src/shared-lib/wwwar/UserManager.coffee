###
# Wa-Wa-War Logic UserManager Class
###
if module?
	LogicBase = require __dirname + '/LogicBase'
	User = require __dirname + '/User'

class UserManager extends LogicBase
	constructor: ->
		@users = {}

	addUser: (number) ->
		@users[number] = new User(number)

	removeUser: (number) ->
		@users[number] = null

	addInput: (number, inputList) ->
		if !@users[number]?
			console.log 'Error : No.' + number + ' のユーザは生成されていない'
			return
		@users[number].addInput inputList

	tick: ->
		for number, user of @users
			user.tick()

	makeSnapshot: ->
		snapshot = []
		for number, user of @users
			if user is null then continue
			snapshot.push [number, user.makeSnapshot()]
		return snapshot

if module?
	module.exports = UserManager
else
	window.wwwar = window.wwwar || {}
	window.wwwar.UserManager = UserManager
