###
# Wa-Wa-War Logic UserManager Class
###
if require?
	Logger = require __dirname + '/../Logger'
	LogicBase = require __dirname + '/LogicBase'
	LogicUser = require __dirname + '/LogicUser'

class LogicUserManager extends LogicBase
	users: {}
	userCount: 0

	applyInput: (inputData) ->
		# inputData = [uid, [flags, flags,...]]
		uid = inputData[0]
		inputList = inputData[1]

		if !@users[uid]?
			Logger.error 'uid=%s is not created', uid
			return
		@users[uid].applyInput(inputList)

	addUser: (uid) ->
		if @users[uid]?
			Logger.error 'uid=%s is already exists', uid
			return false

		@users[uid] = new LogicUser(uid)
		@add @users[uid]
		@userCount++
		return true

	removeUser: (uid) ->
		if !@users[uid]?
			Logger.error 'uid=%s is undefined', uid
			return false

		@remove @users[uid]
		@users[uid] = null
		@userCount--
		return true

	deserialize: (serialized) ->
		detected = []
		# ユーザ追加
		for user in serialized
			uid = user[0]
			if !@users[uid]?
				@addUser uid
			detected.push uid

		# ユーザ削除
		if detected.length < @userCount
			for uid, user of @users
				if detected.indexOf uid is -1
					@removeUser uid
					break

		super()
		return

module.exports = LogicUserManager if module?
