###
# Wa-Wa-War Logic World Data Class
###
if module?
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

if module?
	module.exports = LogicWorld
