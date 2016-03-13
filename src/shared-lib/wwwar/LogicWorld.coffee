###
# Wa-Wa-War Logic World Data Class
###
if require?
	LogicBase = require __dirname + '/LogicBase'
	LogicMeta = require __dirname + '/LogicMeta'
	LogicUserManager = require __dirname + '/LogicUserManager'

class LogicWorld extends LogicBase
	constructor: ->
		super()
		@meta = new LogicMeta()
		@userManager = new LogicUserManager()
		@add @meta
		@add @userManager
		return

module.exports = LogicWorld if module?
